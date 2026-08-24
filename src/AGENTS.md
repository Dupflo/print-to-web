# print-to-web — Règles du repo

## Règle absolue
Pas de maquette ni de génération visuelle en direct. Tout projet print → web passe par le pipeline, dans l'ordre :

Analyse → Brief (PRD) → Stories → Design System → Wireframe → Assets → Maquette → (bonus : HTML)

Aucune maquette n'est générée avant que le PRD soit validé (`docs/prd.md` → frontmatter `validated: yes`) et que le design system existe. Aucune identité visuelle n'est inventée : elle est extraite des documents print et des inspirations fournies.

## Pipeline (commandes)
- `/ptw-analyze <dossier>`  analyse le dossier print : inventaire des assets, identité visuelle, structure de contenu, recommandation de format web
- `/ptw-brief`              questionnaire en une passe → PRD : objectif, format validé, périmètre, fonctionnalités, contraintes
- `/ptw-stories`            user stories visiteur, légères — jamais overkill
- `/ptw-design-system`      design system markdown : tokens extraits du print + analyse des inspirations + prompts design
- `/ptw-wireframe`          wireframe maison en markdown/ASCII, mappé sur le contenu réel
- `/ptw-assets`             optimisation des images : resize + WebP sans dégradation visible, originaux intacts
- `/ptw-mockup`             maquette — Figma via MCP (défaut) ou Claude Design, à partir du brief de maquette
- `/ptw-html`               bonus : prototype HTML/CSS statique navigable

Utilitaires :
- `/ptw`         orchestrateur : enchaîne tout le pipeline avec checkpoints humains
- `/ptw-status`  état du projet dérivé des fichiers, prochaine commande
- `/ptw-help`    carte du pipeline (antisèche)

## Gates (mécaniques, fail-closed)
- `/ptw-brief` refuse de tourner sans `docs/analyse.md` — le questionnaire doit être éclairé par l'analyse.
- `/ptw-design-system` refuse de tourner sans `docs/analyse.md` ET sans source visuelle (identité print ou dossier d'inspirations). Interdiction absolue d'inventer une identité par défaut.
- `/ptw-wireframe` refuse de tourner sans `docs/prd.md`.
- `/ptw-mockup` refuse de tourner si `docs/prd.md` ne contient pas `validated: yes` dans son frontmatter, ou si `docs/design-system.md` ou `docs/wireframe.md` manquent. Pas de fichier, pas de marqueur → pas de maquette. Aucune exception.
- Le marqueur `validated: yes` est posé uniquement par la validation humaine explicite (checkpoint AskUserQuestion de /ptw-brief ou de l'orchestrateur), jamais par la simple existence du fichier.

## Contenu
- Tout texte de la maquette vient des documents print analysés ou a été validé par l'utilisateur. Lorem ipsum interdit. Un contenu manquant = un "trou de contenu" signalé dans docs/analyse.md ou docs/prd.md, jamais comblé en freestyle.
- Les chiffres, contacts et mentions légales sont recopiés verbatim depuis le print — jamais reformulés de mémoire.

## Design
- L'identité visuelle (palette, typographies, formes) est extraite des documents print (logo, plaquette) et complétée par les inspirations fournies. `docs/design-system.md` est l'unique référence visuelle ; la maquette et le HTML n'utilisent que ses tokens.
- Un besoin non couvert par le design system = un "gap" à signaler, jamais à combler en inventant.
- Les prompts design (section dédiée du design system) sont la passerelle vers Claude Design / Figma : autonomes, ils contiennent tokens + direction + contenus.

## Assets
- Les fichiers originaux du dossier print ne sont JAMAIS modifiés ni déplacés.
- Les images optimisées vivent dans `assets/web/`, avec un manifeste `docs/assets.md` (original → optimisé, dimensions, poids, usage).
- La maquette et le HTML référencent les assets optimisés, jamais les originaux.

## Données & cycle de vie des docs
Toutes les données du pipeline vivent en markdown sous docs/, versionnées par git quand le projet est un repo. Pas de base, pas de fichier d'état : l'état se dérive des fichiers (l'analyse est faite si docs/analyse.md existe, le PRD est validé si son frontmatter dit `validated: yes`) — un état dérivé ne périme pas.

- docs/analyse.md — inventaire + identité + structure + recommandation de format
- docs/prd.md — périmètre du site (frontmatter `validated: yes|no`)
- docs/stories.md — user stories visiteur
- docs/design-system.md — tokens, composants, patterns, prompts design
- docs/wireframe.md — wireframe sections desktop + notes mobile
- docs/assets.md — manifeste des images optimisées
- docs/mockup-brief.md — brief de maquette autonome (écrit par /ptw-mockup avant toute génération)

Si le projet est un repo git, chaque doc est commité à la fin de sa phase (`docs: <phase>`). Sinon, les fichiers suffisent.

## Definition of Done (par projet)
- PRD validé par l'humain, périmètre et graveyard explicites
- Design system ancré dans l'identité print réelle (zéro token inventé)
- Wireframe mappé sur du contenu réel (zéro lorem)
- Assets optimisés WebP avec manifeste
- Maquette livrée (lien Figma ou sortie Claude Design) + brief de maquette réutilisable
