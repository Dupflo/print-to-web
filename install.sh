#!/usr/bin/env bash
set -euo pipefail

# print-to-web installer
#
# Usage :
#   ./install.sh                       Projet (défaut), cible Claude Code
#   ./install.sh --target codex        Projet, cible Codex (.codex/skills + AGENTS.md)
#   ./install.sh --target all          Projet, Claude + Codex
#   ./install.sh --global              Global Claude (~/.claude) — commandes dans tous les repos
#   ./install.sh --global --target codex   Global Codex (~/.codex/skills)
#   ./install.sh --global --target all     Global Claude + Codex
#   ./install.sh init [--target …]     Pose templates + rules dans le projet (après un global)
#   ./install.sh update [--target …]   Met à jour LÀ OÙ c'est installé (projet et/ou global ; préserve tes modifs)
#   ./install.sh check                 Compare la version installée à la version distante (exit 10 si maj dispo)
#   --force                            Écrase aussi les templates modifiés localement
#
# Deux portées, pour chaque cible : projet (dans le repo courant) ou global (--global).

REPO="https://github.com/Dupflo/print-to-web.git"

# --- Résolution du payload (src/) : fichiers locaux, sinon clone (cas curl|bash) ---
SELF_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd || true)"
if [ -n "${SELF_DIR:-}" ] && [ -f "$SELF_DIR/src/commands/ptw-analyze.md" ]; then
  SRC="$SELF_DIR/src"
  PAYLOAD_ROOT="$SELF_DIR"
else
  TMP="$(mktemp -d)"
  echo "→ Récupération de print-to-web…"
  git clone --depth 1 "$REPO" "$TMP" >/dev/null 2>&1
  SRC="$TMP/src"
  PAYLOAD_ROOT="$TMP"
fi

VERSION="$(git -C "$PAYLOAD_ROOT" rev-parse --short HEAD 2>/dev/null || date +%Y-%m-%d)"
CACHE="$HOME/.claude/print-to-web"
ORIG="./.print-to-web/templates.orig"   # baseline templates, pour détecter les modifs locales

# --- Arguments : mode + --target + --force ---
FORCE=0; TARGET="claude"; TARGET_SET=0; MODE=""
while [ $# -gt 0 ]; do
  case "$1" in
    -f|--force)   FORCE=1 ;;
    --target)     TARGET="${2:-}"; TARGET_SET=1; shift ;;
    --target=*)   TARGET="${1#--target=}"; TARGET_SET=1 ;;
    *)            MODE="$1" ;;
  esac
  shift
done

# Supprime les fichiers posés par une install précédente (listés dans .ptw-manifest) — jamais rien d'autre.
clean_tooling() {
  local dest="$1" line
  [ -f "$dest/.ptw-manifest" ] || return 0
  while IFS= read -r line; do
    case "$line" in
      commands/*|skills/*) rm -rf "$dest/$line" ;;
    esac
  done < "$dest/.ptw-manifest"
}

# Claude : copie verbatim (pas de build, pas de Node — chemin quotidien).
copy_tooling_claude() {
  local dest="$1" f
  clean_tooling "$dest"
  mkdir -p "$dest/commands"
  cp -R "$SRC/commands/." "$dest/commands/"
  : > "$dest/.ptw-manifest"
  for f in "$SRC/commands/"*.md; do echo "commands/$(basename "$f")" >> "$dest/.ptw-manifest"; done
  if [ -d "$SRC/skills" ] && [ -n "$(ls -A "$SRC/skills" 2>/dev/null)" ]; then
    mkdir -p "$dest/skills"
    cp -R "$SRC/skills/." "$dest/skills/"
    for f in "$SRC/skills/"*/; do echo "skills/$(basename "$f")" >> "$dest/.ptw-manifest"; done
  fi
  echo "$VERSION" > "$dest/.ptw-version"
}

# Codex : transforme via le build Node → .codex/skills.
copy_tooling_codex() {
  local dest="$1" stg d
  command -v node >/dev/null 2>&1 || { echo "✗ Node requis pour la cible codex (build md→skills)." >&2; return 1; }
  stg="$(mktemp -d)"
  node "$PAYLOAD_ROOT/bin/ptw-build.mjs" --target codex --src "$SRC" --out "$stg" >/dev/null
  clean_tooling "$dest"
  mkdir -p "$dest"
  cp -R "$stg/." "$dest/"
  : > "$dest/.ptw-manifest"
  for d in "$dest/skills/"*/; do echo "skills/$(basename "$d")" >> "$dest/.ptw-manifest"; done
  echo "$VERSION" > "$dest/.ptw-version"
  rm -rf "$stg"
}

# Copie un template seulement s'il est absent ou non modifié localement (baseline : $ORIG).
sync_templates() {
  local payload="$1" f name
  mkdir -p ./templates "$ORIG"
  for f in "$payload/templates/"*; do
    name="$(basename "$f")"
    if [ ! -f "./templates/$name" ]; then
      cp "$f" "./templates/$name"; cp "$f" "$ORIG/$name"
    elif [ -f "$ORIG/$name" ] && cmp -s "./templates/$name" "$ORIG/$name"; then
      cp "$f" "./templates/$name"; cp "$f" "$ORIG/$name"
    elif cmp -s "./templates/$name" "$f"; then
      cp "$f" "$ORIG/$name"
    elif [ "$FORCE" = 1 ]; then
      cp "$f" "./templates/$name"; cp "$f" "$ORIG/$name"
      echo "↻  templates/$name écrasé (--force)."
    else
      echo "⚠  templates/$name modifié localement — non écrasé (relance avec --force pour l'écraser)."
    fi
  done
}

# AGENTS.md est la source de règles partagée (native pour Codex, importée par CLAUDE.md pour Claude).
drop_agents_md() {
  local payload="$1"
  if [ -f ./AGENTS.md ]; then
    echo "⚠  ./AGENTS.md existe déjà — non écrasé. Fusionne les rules print-to-web à la main si besoin."
  else
    cp "$payload/AGENTS.md" ./AGENTS.md
  fi
}
wire_claude_md() {
  if [ -f ./CLAUDE.md ]; then
    grep -qxF '@AGENTS.md' ./CLAUDE.md || printf '\n@AGENTS.md\n' >> ./CLAUDE.md
  else
    printf '@AGENTS.md\n' > ./CLAUDE.md
  fi
}

# Compare la version installée (.ptw-version, la plus proche : projet puis global) au HEAD distant.
# Sorties : 0 à jour, 10 mise à jour disponible, 1 pas d'install / distant injoignable.
check_updates() {
  local installed="" where="" dest remote
  for dest in ./.claude ./.codex "$HOME/.claude" "$HOME/.codex"; do
    if [ -f "$dest/.ptw-version" ]; then installed="$(cat "$dest/.ptw-version")"; where="$dest"; break; fi
  done
  [ -n "$installed" ] || { echo "✗ print-to-web n'est installé ni dans ce projet ni en global (pas de .ptw-version)." >&2; return 1; }
  remote="$(git ls-remote "$REPO" HEAD 2>/dev/null | cut -f1)"
  [ -n "$remote" ] || { echo "⚠  Impossible de joindre $REPO (hors-ligne ?)." >&2; return 1; }
  case "$remote" in
    "$installed"*)
      echo "✅ À jour (version $installed, installée dans $where)." ;;
    *)
      echo "⬆  Mise à jour disponible : installé $installed ($where) → distant ${remote:0:7}."
      echo "   Applique-la : ./install.sh update  (ou : curl -fsSL https://raw.githubusercontent.com/Dupflo/print-to-web/main/install.sh | bash -s -- update)"
      return 10 ;;
  esac
}

# Cache partagé (templates + AGENTS.md + installeur) pour `init` par projet, après un global.
seed_cache() {
  mkdir -p "$CACHE"
  cp -R "$SRC/templates" "$CACHE/"
  cp "$SRC/AGENTS.md" "$CACHE/"
  cp "$PAYLOAD_ROOT/install.sh" "$CACHE/install.sh" 2>/dev/null \
    || cp "${BASH_SOURCE[0]:-$0}" "$CACHE/install.sh" 2>/dev/null || true
}

# Met à jour là où print-to-web est déjà installé (projet et/ou global, claude et/ou codex).
# Respecte --target s'il est passé explicitement ; sinon met à jour tout ce qui existe.
# Retour : 0 si au moins une installation mise à jour, 1 sinon.
update_existing() {
  local did=0
  want() { [ "$TARGET_SET" = 0 ] || [ "$TARGET" = all ] || [ "$TARGET" = "$1" ]; }
  if [ -f ./.claude/.ptw-version ] && want claude; then install_target claude; did=1; fi
  if [ -f ./.codex/.ptw-version ]  && want codex;  then install_target codex;  did=1; fi
  if [ -f "$HOME/.claude/.ptw-version" ] && want claude; then
    copy_tooling_claude "$HOME/.claude"; seed_cache
    echo "✅ print-to-web mis à jour (global Claude, version $VERSION)."; did=1
  fi
  if [ -f "$HOME/.codex/.ptw-version" ] && want codex; then
    copy_tooling_codex "$HOME/.codex"; seed_cache
    echo "✅ print-to-web mis à jour (global Codex, version $VERSION)."; did=1
  fi
  [ "$did" = 1 ]
}

install_target() {
  case "$1" in
    claude)
      copy_tooling_claude "./.claude"
      sync_templates "$SRC"; drop_agents_md "$SRC"; wire_claude_md
      echo "✅ print-to-web installé (Claude, projet, version $VERSION). Commandes : /ptw, /ptw-analyze … /ptw-html" ;;
    codex)
      copy_tooling_codex "./.codex"
      sync_templates "$SRC"; drop_agents_md "$SRC"   # AGENTS.md natif Codex, pas de CLAUDE.md
      echo "✅ print-to-web installé (Codex, projet, version $VERSION). Skills : ptw-analyze … ptw-html dans .codex/skills." ;;
    all)
      install_target claude
      install_target codex ;;
    *)
      echo "Cible inconnue : $1 (claude|codex|all)" >&2; exit 1 ;;
  esac
}

case "$MODE" in
  ""|--project)
    # Une installation globale existe et rien dans ce projet ? Installer « nu » écrirait
    # commandes + templates + AGENTS.md dans le dossier courant SANS mettre à jour ce qui
    # est réellement installé. On propose la mise à jour du global à la place.
    if [ ! -f ./.claude/.ptw-version ] && [ ! -f ./.codex/.ptw-version ] \
       && { [ -f "$HOME/.claude/.ptw-version" ] || [ -f "$HOME/.codex/.ptw-version" ]; }; then
      echo "⚠  print-to-web est déjà installé en global (~/.claude ou ~/.codex), pas dans ce projet."
      answer=""
      # /dev/tty peut exister sans être ouvrable (curl | bash détaché) : on teste l'ouverture réelle.
      if { printf "   Mettre à jour l'installation globale plutôt qu'installer dans ce dossier ? [O/n] " > /dev/tty; } 2>/dev/null; then
        read -r answer < /dev/tty || answer="O"
      else
        answer="O"   # non interactif : le global gagne, jamais de dépôt surprise dans le dossier courant
      fi
      case "$answer" in
        n|N|non|no)
          install_target "$TARGET" ;;
        *)
          update_existing
          echo "→ Pour poser templates + rules dans CE projet : ~/.claude/print-to-web/install.sh init" ;;
      esac
    else
      install_target "$TARGET"
    fi
    ;;

  -g|--global)
    case "$TARGET" in
      claude)
        copy_tooling_claude "$HOME/.claude"; seed_cache
        echo "✅ Tooling installé (global Claude, version $VERSION). Commandes dans tous tes repos." ;;
      codex)
        copy_tooling_codex "$HOME/.codex"; seed_cache
        echo "✅ Tooling installé (global Codex, version $VERSION). Skills dans ~/.codex/skills." ;;
      all)
        copy_tooling_claude "$HOME/.claude"; copy_tooling_codex "$HOME/.codex"; seed_cache
        echo "✅ Tooling installé (global Claude + Codex, version $VERSION)." ;;
      *) echo "Cible inconnue : $TARGET (claude|codex|all)" >&2; exit 1 ;;
    esac
    echo "→ Dans chaque projet : ~/.claude/print-to-web/install.sh init [--target codex]"
    ;;

  init)
    local_src="$SRC"; [ -d "$local_src/templates" ] || local_src="$CACHE"
    sync_templates "$local_src"; drop_agents_md "$local_src"
    case "$TARGET" in claude|all) wire_claude_md ;; esac   # CLAUDE.md seulement si Claude est cible
    echo "✅ templates + rules ajoutés à $(pwd) (cible $TARGET)"
    ;;

  check)
    check_updates
    ;;

  update)
    # « update » met à jour LÀ OÙ c'est installé (projet et/ou global) — jamais une install neuve en douce.
    if update_existing; then
      echo "ℹ  AGENTS.md du projet jamais écrasé — fusionne à la main si les rules ont évolué."
    else
      echo "✗ Aucune installation print-to-web trouvée (ni ./.claude, ./.codex, ~/.claude, ~/.codex)." >&2
      echo "  Installe d'abord : ./install.sh [--global] [--target claude|codex|all]" >&2
      exit 1
    fi
    ;;

  *)
    echo "Option inconnue : $MODE" >&2
    echo "Usage : ./install.sh [--target claude|codex|all] [--global | init | update | check] [--force]" >&2
    exit 1
    ;;
esac
