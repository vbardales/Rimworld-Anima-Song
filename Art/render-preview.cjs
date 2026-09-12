// Requires Node.js, playwright and sharp. Run from any directory.
// Uses an ephemeral local HTTP server; never publishes the composition.
const fs = require('fs');
const path = require('path');
const http = require('http');
const { chromium } = require('playwright');
const sharp = require('sharp');
const root = __dirname;
const palette = JSON.parse(fs.readFileSync(path.join(root,'preview-palette.json')));
const layout = JSON.parse(fs.readFileSync(path.join(root,'preview-layout.json')));
const about = fs.readFileSync(path.join(root,'../Mod/About/About.xml'),'utf8');
const versions = [...about.match(/<supportedVersions>([\s\S]*?)<\/supportedVersions>/)[1].matchAll(/<li>(\d+(?:\.\d+)+)<\/li>/g)].map(m=>m[1]);
versions.sort((a,b)=>{const aa=a.split('.').map(Number),bb=b.split('.').map(Number);for(let i=0;i<Math.max(aa.length,bb.length);i++){if((aa[i]||0)!==(bb[i]||0))return (aa[i]||0)-(bb[i]||0);}return 0;});
if(layout.version !== versions.at(-1)) throw Error('Update layout version to match About.xml');
const output = path.join(root,'../Mod/About/Preview.png');
const lum = c => c.map(v=>v/255).map(v=>v<=.04045?v/12.92:((v+.055)/1.055)**2.4).reduce((s,v,i)=>s+v*[.2126,.7152,.0722][i],0);
const rgb = hex => hex.match(/\w\w/g).map(v=>parseInt(v,16));
const contrast = (a,b) => (Math.max(lum(a),lum(b))+.05)/(Math.min(lum(a),lum(b))+.05);
(async()=>{
 const server=http.createServer((req,res)=>{
   const file=path.join(root,decodeURIComponent(req.url.split('?')[0] === '/' ? 'preview.html' : req.url.split('?')[0]));
   if(!file.startsWith(root+path.sep)){res.writeHead(403).end();return;}
   fs.readFile(file,(e,b)=>{if(e){res.writeHead(404).end();return;}res.setHeader('Content-Type',file.endsWith('.png')?'image/png':file.endsWith('.json')?'application/json':'text/html');res.end(b);});
 });
 await new Promise(r=>server.listen(0,'127.0.0.1',r));
 let browser;
 try {
  browser=await chromium.launch({headless:true,channel:'chrome'});
  const page=await browser.newPage({viewport:{width:layout.width,height:layout.height},deviceScaleFactor:1});
  await page.goto(`http://127.0.0.1:${server.address().port}/preview.html`);
  await page.evaluate(()=>window.ready);
  const cdp=await page.context().newCDPSession(page);
  await cdp.send('DOM.enable');await cdp.send('CSS.enable');
  const {root:dom}=await cdp.send('DOM.getDocument');
  const boxes={},fonts={};
  for(const selector of ['h1','.summary','.version']){
   boxes[selector]=await page.locator(selector).boundingBox();
   const {nodeId}=await cdp.send('DOM.querySelector',{nodeId:dom.nodeId,selector});
   fonts[selector]=(await cdp.send('CSS.getPlatformFontsForNode',{nodeId})).fonts;
   if(!fonts[selector].every(f=>/^Segoe UI(?: Semibold| Bold)?$/.test(f.familyName)))throw Error('Unexpected font fallback: '+JSON.stringify(fonts[selector]));
  }
  const screenshot=await page.screenshot();
  await sharp(screenshot).png({compressionLevel:9}).toFile(output);
  await sharp(screenshot).resize({width:268}).png().toFile(path.join(root,'preview-268.png'));
  // Remove all text and shadows, leaving exactly the actual composite backgrounds.
  await page.addStyleTag({content:'.copy,.version {visibility:hidden}'});
  const background=await page.screenshot();
  await fs.promises.writeFile(path.join(root,'preview-background.png'),background);
  const {data,info}=await sharp(background).removeAlpha().raw().toBuffer({resolveWithObject:true});
  const results={};
  for(const selector of ['h1','.summary']){
   const box=boxes[selector];let min=Infinity,point;
   for(let y=Math.floor(box.y);y<Math.ceil(box.y+box.height);y++)for(let x=Math.floor(box.x);x<Math.ceil(box.x+box.width);x++){
    const i=(y*info.width+x)*3,c=contrast(rgb(palette.inkPrimary),[...data.subarray(i,i+3)]);
    if(c<min){min=c;point=[x,y];}
   }
   results[selector]={minimumContrast:min,position:point,scope:'Every pixel of the text bounding box on text-free rendered PNG'};
   if(min<4.5)throw Error(selector+' contrast below 4.5');
  }
  results.badge={minimumContrast:contrast(rgb(palette.badgeInk),rgb(palette.accent))};
  if(results.badge.minimumContrast<4.5)throw Error('Badge contrast below 4.5');
  results.tag={status:'Not applicable: original public mod, no tag rendered',paletteContrastOnVeil:contrast(rgb(palette.inkSecondary),rgb(palette.veil))};
  const bytes=fs.statSync(output).size;
  if(bytes>=900000)throw Error('Preview exceeds 900 KB');
  const report={dimensions:[layout.width,layout.height],thumbnailWidth:268,bytes,version:layout.version,fonts,boxes,contrast:results,source:'Art/Preview.png (unchanged copy of Preview-source.png)'};
  fs.writeFileSync(path.join(root,'preview-qa.json'),JSON.stringify(report,null,2)+'\n');
  console.log(JSON.stringify(report,null,2));
 } finally {if(browser)await browser.close();server.close();}
})().catch(e=>{console.error(e);process.exitCode=1;});
