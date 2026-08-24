---
description: Orchestrateur — enchaîne tout le pipeline print → web avec checkpoints humains (PRD, direction visuelle, outil de maquette)
argument-hint: <chemin du dossier print>
---
# ptw — Le pipeline complet, checkpoints conservés

Dossier print : $ARGUMENTS (requis au premier lancement ; ensuite l'état des docs suffit).

Tu conduis le pipeline ; les checkpoints humains sont non négociables et sont de vrais appels AskUserQuestion — jamais une phrase rhétorique dans ta sortie. C'est un chef d'orchestre, pas un autopilote. Chaque phase suit le contrat de sa commande dédiée — même template, mêmes gates, même fichier de sortie. Une phase dont le doc existe déjà est sautée (l'état se dérive des fichiers).

## Phase 1 — Analyse
docs/analyse.md absent → déroule le contrat de /ptw-analyze sur $ARGUMENTS. Sans $ARGUMENTS ni docs/analyse.md → demande le dossier.

## Phase 2 — Brief
docs/prd.md absent ou frontmatter `validated: no` → déroule le contrat de /ptw-brief (questionnaire en une passe, éclairé par l'analyse).

CHECKPOINT PRD — obligatoire, que le PRD soit neuf ou préexistant. S'il dit déjà `validated: yes`, continue. Sinon présente le résumé (format, sections, CTA, graveyard) et demande via AskUserQuestion : "Valider ce PRD ?" — Valider / Modifier / Stop. Un fichier qui existe ne vaut PAS validation. Sur Valider, pose `validated: yes`. Sinon : ne touche pas au marqueur, ne continue pas.

## Phase 3 — Stories
docs/stories.md absent → déroule le contrat de /ptw-stories (léger, 5-12 stories). Phase rapide, pas de checkpoint.

## Phase 4 — Design system
docs/design-system.md absent → déroule le contrat de /ptw-design-system (identité print + inspirations, interdiction d'inventer).

CHECKPOINT direction visuelle — présente les tokens clés (palette, typos, motifs) et les invariants tirés des inspirations, et demande via AskUserQuestion : "Valider cette direction ?" — Valider / Ajuster / Stop. La maquette en découle entièrement : c'est le dernier moment bon marché pour corriger.

## Phase 5 — Wireframe
docs/wireframe.md absent → déroule le contrat de /ptw-wireframe (contenu réel, zéro lorem).

## Phase 6 — Assets
docs/assets.md absent → déroule le contrat de /ptw-assets (WebP, originaux intacts).

## Phase 7 — Maquette
Gate mécanique de /ptw-mockup (PRD `validated: yes` + design system + wireframe), puis CHECKPOINT outil : AskUserQuestion "Générer la maquette avec ?" — Figma via MCP (défaut) / Claude Design / Brief seulement. Déroule le contrat de /ptw-mockup avec ce choix.

## Phase 8 — HTML (optionnel)
Propose /ptw-html en une ligne. Ne le lance que sur demande explicite.

Termine par : "Pipeline complet — maquette : <lien/emplacement>. Brief réutilisable : docs/mockup-brief.md." — ou l'état de blocage exact (quelle phase, ce qui manque).
