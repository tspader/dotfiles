import { existsSync, readFileSync } from "fs";
import { resolve, normalize } from "path";
import { TOML } from "bun";
import { defaultTheme as t } from "@spader/zargs";

export type Entry = {
  name: string;
  source: string;
  target: string;
};

export type Config = Entry[];

const CONFIG_FILE = "splink.toml";

function expand(template: string, vars: Record<string, unknown>): string {
  return template.replace(/\$\{([^}]+)\}/g, (_, expr: string) => {
    const parts = expr.split(".");
    let value: unknown = vars;
    for (const part of parts) {
      value = (value as Record<string, unknown>)?.[part];
    }
    if (typeof value !== "string") {
      throw new Error(`unresolved variable: \${${expr}}`);
    }
    return value;
  });
}

export function loadConfig(): Config | null {
  const configPath = resolve(process.cwd(), CONFIG_FILE);
  if (!existsSync(configPath)) {
    console.log(`no ${t.link(CONFIG_FILE)} detected`);
    return null;
  }

  const raw = TOML.parse(readFileSync(configPath, "utf-8"));
  const root = resolve(process.cwd());

  // build env: start with process.env, then layer on [env] section
  const envSection = (raw.env ?? {}) as Record<string, string>;
  const env: Record<string, string> = {};
  for (const [key, val] of Object.entries(envSection)) {
    env[key] = normalize(expand(val, process.env as Record<string, string>));
  }

  const entries: Entry[] = [];
  for (const [name, section] of Object.entries(raw)) {
    if (name === "env") continue;
    const s = section as Record<string, string>;
    const source = resolve(root, s.source);
    const target = normalize(expand(s.target, { env }));
    entries.push({ name, source, target });
  }

  return entries;
}
