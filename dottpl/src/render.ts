import fs from "node:fs";
import path from "node:path";

type JsonLike = Record<string, unknown>;

function parseDataFile(filePath: string): JsonLike {
  const raw = fs.readFileSync(filePath, "utf8");
  const ext = path.extname(filePath).toLowerCase();

  if (ext === ".json") {
    const parsed = JSON.parse(raw);
    if (!parsed || typeof parsed !== "object") {
      throw new Error(`Data file must be an object: ${filePath}`);
    }
    return parsed as JsonLike;
  }

  if (ext === ".toml") {
    const parsed = Bun.TOML.parse(raw);
    if (!parsed || typeof parsed !== "object") {
      throw new Error(`Data file must be an object: ${filePath}`);
    }
    return parsed as JsonLike;
  }

  throw new Error(`Unsupported data file type: ${filePath}`);
}

function findNearestDataFile(startDir: string): string | null {
  let cur = path.resolve(startDir);

  while (true) {
    const tomlPath = path.join(cur, "dottpl.toml");
    if (fs.existsSync(tomlPath)) return tomlPath;

    const jsonPath = path.join(cur, "dottpl.json");
    if (fs.existsSync(jsonPath)) return jsonPath;

    const parent = path.dirname(cur);
    if (parent === cur) return null;
    cur = parent;
  }
}

function findDataInDir(dir: string): string | null {
  const tomlPath = path.join(dir, "dottpl.toml");
  if (fs.existsSync(tomlPath)) return tomlPath;

  const jsonPath = path.join(dir, "dottpl.json");
  if (fs.existsSync(jsonPath)) return jsonPath;

  return null;
}

function shouldSkipDir(name: string): boolean {
  return name === ".git" || name === "node_modules" || name === ".llm";
}

function collectTplFiles(rootDir: string): string[] {
  const out: string[] = [];

  const walk = (dir: string): void => {
    const entries = fs.readdirSync(dir, { withFileTypes: true });
    for (const entry of entries) {
      const full = path.join(dir, entry.name);
      if (entry.isDirectory()) {
        if (shouldSkipDir(entry.name)) continue;
        walk(full);
        continue;
      }
      if (entry.isFile() && full.endsWith(".tpl")) {
        out.push(full);
      }
    }
  };

  walk(rootDir);
  out.sort();
  return out;
}

function getPathValue(data: unknown, keyPath: string): unknown {
  const parts = keyPath.split(".").map((s) => s.trim()).filter(Boolean);
  let cur: unknown = data;

  for (const part of parts) {
    if (!cur || typeof cur !== "object" || !(part in (cur as Record<string, unknown>))) {
      return undefined;
    }
    cur = (cur as Record<string, unknown>)[part];
  }

  return cur;
}

export function renderTemplate(template: string, data: JsonLike): string {
  return template.replaceAll(/{{\s*([^{}]+?)\s*}}/g, (_full, rawExpr: string) => {
    const expr = rawExpr.trim();
    const value = getPathValue(data, expr);

    if (value === undefined) {
      throw new Error(`Missing template value: ${expr}`);
    }

    if (value === null) return "";
    if (typeof value === "string") return value;
    if (typeof value === "number" || typeof value === "boolean") return String(value);

    throw new Error(`Template value must be scalar: ${expr}`);
  });
}

export function renderFile(
  templateFile: string,
  dataFile?: string,
): { templatePath: string; outputPath: string; dataPath?: string } {
  const resolvedTemplate = path.resolve(templateFile);

  if (!resolvedTemplate.endsWith(".tpl")) {
    throw new Error(`Template file must end with .tpl: ${templateFile}`);
  }

  if (!fs.existsSync(resolvedTemplate)) {
    throw new Error(`Template file not found: ${templateFile}`);
  }

  const resolvedData = dataFile
    ? path.resolve(dataFile)
    : findNearestDataFile(path.dirname(resolvedTemplate)) ?? undefined;

  const data = resolvedData ? parseDataFile(resolvedData) : {};
  const template = fs.readFileSync(resolvedTemplate, "utf8");
  const output = renderTemplate(template, data);
  const outputPath = resolvedTemplate.slice(0, -4);

  fs.writeFileSync(outputPath, output);

  return {
    templatePath: resolvedTemplate,
    outputPath,
    dataPath: resolvedData,
  };
}

export function renderTarget(
  target?: string,
  dataFile?: string,
): Array<{ templatePath: string; outputPath: string; dataPath?: string }> {
  const resolvedTarget = path.resolve(target ?? process.cwd());

  if (!fs.existsSync(resolvedTarget)) {
    throw new Error(`Path not found: ${target ?? process.cwd()}`);
  }

  const stat = fs.statSync(resolvedTarget);
  let templates: string[] = [];

  if (stat.isFile()) {
    if (!resolvedTarget.endsWith(".tpl")) {
      throw new Error(`File is not a .tpl template: ${resolvedTarget}`);
    }
    templates = [resolvedTarget];
  } else if (stat.isDirectory()) {
    templates = collectTplFiles(resolvedTarget);
  } else {
    throw new Error(`Unsupported path type: ${resolvedTarget}`);
  }

  const cwdData = findDataInDir(process.cwd()) ?? undefined;
  const sharedData = dataFile ? path.resolve(dataFile) : cwdData;

  const results: Array<{ templatePath: string; outputPath: string; dataPath?: string }> = [];
  for (const tpl of templates) {
    results.push(renderFile(tpl, sharedData));
  }

  return results;
}
