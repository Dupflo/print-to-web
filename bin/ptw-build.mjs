#!/usr/bin/env node
// ptw-build — émet le tooling print-to-web pour une cible donnée depuis le src/ canonique.
// Zéro dépendance externe. Produit un arbre de staging que install.sh copie en place.
//
//   node bin/ptw-build.mjs --target codex --src ./src --out /tmp/ptw-stg
//
// Cibles :
//   claude  identité : commands/, skills/ copiés tels quels (parité avec le chemin bash)
//   codex   commands -> skills Codex (SKILL.md + agents/openai.yaml), skills verbatim.
//           AGENTS.md est natif (géré par install.sh).
//
// La source canonique reste au format Claude ; seules deux macros sont réécrites : l'injection
// `@path` (spécifique Claude) devient une référence de chemin simple, `$ARGUMENTS` est conservé
// (natif Codex).

import { readdirSync, readFileSync, mkdirSync, writeFileSync, statSync, cpSync } from "node:fs";
import { join, basename } from "node:path";

function parseArgs(argv) {
  const a = {};
  for (let i = 0; i < argv.length; i++) {
    if (argv[i].startsWith("--")) a[argv[i].slice(2)] = argv[i + 1];
  }
  return a;
}

// Découpe minimale du frontmatter. Retourne { fm: yamlBrut, body }.
function splitFrontmatter(text) {
  if (!text.startsWith("---")) return { fm: "", body: text };
  const end = text.indexOf("\n---", 3);
  if (end === -1) return { fm: "", body: text };
  const fm = text.slice(3, end).replace(/^\n/, "");
  const body = text.slice(end + 4).replace(/^\n/, "");
  return { fm, body };
}

// Lit une clé scalaire simple dans un frontmatter brut (`key: value` de premier niveau).
function fmScalar(fm, key) {
  const m = fm.match(new RegExp(`^${key}:[ \\t]*(.+?)[ \\t]*$`, "m"));
  return m ? m[1].trim() : "";
}

// Injection `@path` (Claude) -> référence de chemin simple ; $ARGUMENTS conservé (natif Codex).
function derefInjections(body) {
  return body
    .replace(/@templates\//g, "templates/")
    .replace(/@AGENTS\.md/g, "AGENTS.md");
}

function ensureDir(p) { mkdirSync(p, { recursive: true }); }

function listFiles(dir) {
  try { return readdirSync(dir); } catch { return []; }
}
function isDir(p) { try { return statSync(p).isDirectory(); } catch { return false; } }

// ---- ÉMISSION CODEX -------------------------------------------------------

function codexSkillFromCommand(name, text, outSkillsDir) {
  const { fm, body } = splitFrontmatter(text);
  const description = fmScalar(fm, "description") || `commande print-to-web ${name}`;
  const argHint = fmScalar(fm, "argument-hint");
  const skillDir = join(outSkillsDir, name);
  ensureDir(join(skillDir, "agents"));

  // SKILL.md : frontmatter open-standard (name + description) + corps transformé.
  const skillFm = `---\nname: ${name}\ndescription: ${description}\n---\n`;
  const preamble =
    `> Commande print-to-web, émise pour Codex. Lance-la explicitement. ` +
    `Les gates fichiers (frontmatter validated, docs manquants) sont inchangés.\n\n`;
  writeFileSync(join(skillDir, "SKILL.md"), skillFm + preamble + derefInjections(body));

  // agents/openai.yaml : l'interface /ptw-*.
  const defaultPrompt = argHint
    ? `Run ${name} ${argHint}`
    : `Run the ${name} step of the print-to-web pipeline.`;
  const yaml =
    `interface:\n` +
    `  display_name: "/${name}"\n` +
    `  short_description: ${JSON.stringify(description)}\n` +
    `  default_prompt: ${JSON.stringify(defaultPrompt)}\n`;
  writeFileSync(join(skillDir, "agents", "openai.yaml"), yaml);
}

function emitCodex(src, out) {
  const skillsOut = join(out, "skills");
  ensureDir(skillsOut);
  // Commands -> command-skills (explicites, avec interface openai.yaml).
  for (const f of listFiles(join(src, "commands")).filter((f) => f.endsWith(".md"))) {
    const name = basename(f, ".md");
    codexSkillFromCommand(name, readFileSync(join(src, "commands", f), "utf8"), skillsOut);
  }
  // Skills méthodologiques -> verbatim (invocation implicite, même standard ouvert).
  for (const d of listFiles(join(src, "skills")).filter((d) => isDir(join(src, "skills", d)))) {
    cpSync(join(src, "skills", d), join(skillsOut, d), { recursive: true });
  }
}

// ---- ÉMISSION CLAUDE (identité, pour --target all / tests de parité) ------

function emitClaude(src, out) {
  for (const kind of ["commands", "skills"]) {
    const from = join(src, kind);
    if (!isDir(from)) continue;
    ensureDir(join(out, kind));
    cpSync(from, join(out, kind), { recursive: true });
  }
}

// ---- MAIN -----------------------------------------------------------------

const args = parseArgs(process.argv.slice(2));
const target = args.target;
const src = args.src;
const out = args.out;
if (!target || !src || !out) {
  console.error("usage: ptw-build.mjs --target claude|codex --src <dir> --out <dir>");
  process.exit(2);
}
ensureDir(out);
if (target === "codex") emitCodex(src, out);
else if (target === "claude") emitClaude(src, out);
else { console.error(`unknown target: ${target}`); process.exit(2); }
console.log(`ptw-build: emitted ${target} into ${out}`);
