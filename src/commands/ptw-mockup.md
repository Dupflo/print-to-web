---
description: Générer la maquette — brief de maquette autonome puis génération Figma via MCP (défaut) ou Claude Design
argument-hint: (optionnel) figma | claude-design | brief-only
---
# ptw-mockup — La maquette, ancrée dans le système

Utilise ce template pour le brief :
@templates/mockup-brief.md

## Gate (mécanique, fail-closed)
1. docs/prd.md contient `validated: yes` dans son frontmatter ? Non → STOP : "PRD non validé — relance /ptw-brief pour le checkpoint de validation." Pas de fichier, pas de marqueur → pas de maquette. Aucune exception.
2. docs/design-system.md et docs/wireframe.md existent ? Manquant → STOP en pointant la commande.
3. docs/assets.md existe ? Absent → préviens (la maquette utilisera des placeholders d'images nommés d'après le dossier print) mais continue si l'utilisateur confirme.

## Étape 1 — Le brief de maquette (toujours, quel que soit l'outil)
Écris docs/mockup-brief.md AVANT toute génération : un document autonome qui permettrait à n'importe quel outil (ou n'importe quel designer) de produire la maquette sans lire le reste. Il compile : tokens du design system, direction visuelle (invariants des inspirations), section par section le wireframe avec le contenu réel et l'asset optimisé associé (chemin `assets/web/…`), les Do/Don't. Rien d'inventé : tout vient des docs du pipeline.

## Étape 2 — L'outil
$ARGUMENTS fixe l'outil s'il est fourni. Sinon demande via AskUserQuestion : **Figma via MCP** (défaut — la maquette arrive directement dans Figma, retravaillable par le designer) / **Claude Design** (génération là-bas, export Figma manuel ensuite) / **Brief seulement** (docs/mockup-brief.md est le livrable, à coller dans l'outil du designer).

### Figma via MCP
1. Les outils MCP Figma doivent être disponibles (sinon : dis d'ouvrir la connexion Figma dans Claude, et replie-toi sur "Brief seulement").
2. Lis d'abord le skill `figma-generate-design` (ou à défaut `figma-use` / la ressource skill://figma) — obligatoire avant d'appeler use_figma.
3. Crée un nouveau fichier Figma nommé d'après le projet, uploade les assets optimisés, puis génère la maquette section par section en suivant docs/mockup-brief.md. Frame desktop 1440 ; ajoute une frame mobile 390 pour le hero et une section représentative.
4. Vérifie le rendu (screenshot MCP) contre les Do/Don't du design system ; corrige les écarts flagrants (couleurs hors palette, fonte de substitution non prévue).
5. Livre le lien du fichier Figma.

### Claude Design
Fournis le contenu de docs/mockup-brief.md comme prompt, section par section si l'outil le demande. Rappelle que la sortie sera retravaillée dans Figma : nommer les calques proprement compte.

Si le projet est un repo git, commite le brief (`docs: mockup brief`).

Termine par : "Maquette générée (<outil>) : <lien ou emplacement>. Brief réutilisable : docs/mockup-brief.md. Bonus : /ptw-html pour un prototype navigable."
