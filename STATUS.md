---
mod:          Anima Song
packageId:    nelim.animasong
repo:         Rimworld-Anima-Song
visibility:   public
detached:     yes
stage:        done
licence:      original
licence_at:   an original creation, MIT
dependencies: declared
showcase:     complete
tested_on:
workshop:
remaining:
  - unverified: the fourteen scenarios of TESTING.md, none played
  - unverified: grafting the comp onto the tree, which a PatchOperationConditional can miss without a word
  - unverified: the halo, maintained tick by tick by the job, at 3x speed
  - unverified: the seventh colonist refused in the menu, never replayed since its fix
  - unverified: pass B, with Phytokin - sound and icon looked up by def name
  - unverified: the French translation of the memory, whose key addresses the stage by its handle
session:      local_5e30f42a-ec8b-4932-9f21-00964209cc65
updated:      2026-09-12, session du mod
---

# Anima Song — status

Read by a sweep across every mod, rather than by asking each thread in turn. It lives at the
root, never inside `Mod/`, so Steam never receives it.

Les champs deduits du disque le 2026-09-12 ont ete verifies un a un et sont justes. Les trois
que le releve ne pouvait pas remplir sont tranches ici.

- **`etape`** — `done` confirme, et le groupe de session dit la meme chose. Le developpement est
- **`dependencies`** — `declared` when every mod this one needs is named in the About's
  `modDependencies`, `to check` when a non-vanilla `loadAfter` suggests a dependency that is not
  declared, `none` when the mod needs nothing. An undeclared dependency is not cosmetic: on
  2026-09-11 Reequilibrage animaux took 47 vanilla animals down with it, Muffalo included, because
  the class it injects belongs to a mod that was not declared and not loaded.

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
