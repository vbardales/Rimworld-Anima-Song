---
mod:        Anima Song
packageId:  nelim.animasong
repo:            Rimworld-Anima-Song
visibility: public
detached:      yes
stage:           done
licence:    original
licence_at: création originale, MIT
showcase:      complete
tested_on: 
workshop:   
remaining: 
  - unverified: les quatorze scenarios de TESTING.md, aucun joue
  - unverified: la greffe du comp sur l'arbre, qu'un PatchOperationConditional rate sans rien dire
  - unverified: le halo, entretenu tick par tick par le job, a vitesse 3x
  - unverified: le septieme auditeur refuse dans le menu, jamais rejoue depuis son correctif
  - unverified: la passe B, avec Phytokin - son et icone cherches par nom de def
  - unverified: la traduction FR du souvenir, dont la cle adresse l'etage par sa poignee
session:    local_5e30f42a-ec8b-4932-9f21-00964209cc65
updated:           2026-09-12, session du mod
---

# Anima Song — status

Read by a sweep across every mod, rather than by asking each thread in turn. It lives at the
root, never inside `Mod/`, so Steam never receives it.

Les champs deduits du disque le 2026-09-12 ont ete verifies un a un et sont justes. Les trois
que le releve ne pouvait pas remplir sont tranches ici.

- **`etape`** — `done` confirme, et le groupe de session dit la meme chose. Le developpement est
  fini, la paperasse de publication ecrite, le depot public rempli d'un commit d'import. Rien
  n'attend de code. Ce qui reste ne tient pas dans ce champ : l'essai en jeu et l'envoi Steam se
  lisent a `teste_le` et `workshop`, vides tous les deux.
- **`teste_le`** — vide, et c'est exact : le mod n'a jamais ete lance. `TESTING.md` s'ouvre sur
  cette phrase. La liste de mods est prete pour la passe A, Anima Song et Royalty actifs,
  Phytokin inactif, et la jonction de `RimWorld\Mods` pointe bien sur `Mod/`.
- **`reste`** — la ligne posee d'office disait vrai pour ce mod ; elle est detaillee plutot que
  remplacee. Aucun defaut connu non corrige, aucune fonctionnalite manquante au premier jet : ce
  qui reste est du non verifie. Les cinq lignes nommees sont celles dont l'echec serait muet, ou
  dont le correctif n'a jamais ete rejoue. La greffe du comp vient en tete parce qu'elle
  conditionne tout le reste et qu'un `PatchOperationConditional` qui ne trouve rien ne le dit
  d'aucune facon.

Hors des trois categories, il reste le tag `v1.0.0` et la release GitHub que le `CHANGELOG.md`
annonce. Ils attendent que quelque chose ait tourne : dater une version que personne n'a vue
marcher ne servirait personne.

`TESTING.md` reste la source : il dit pour chaque scenario ce qu'il prouve et a quoi ressemble
son echec. Cette fiche n'en garde que le solde.

`licence` vocabulary: `open` an explicit licence, `silent` no licence and a dead source,
`alive` no licence but a living source, `forbidden` a written refusal, `original` nothing reused.
