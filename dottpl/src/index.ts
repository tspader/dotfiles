#!/usr/bin/env bun
import path from "node:path";
import { build, type CliDef, type CommandDef } from "./cli/index.ts";
import { renderTarget } from "./render.ts";

const render: CommandDef = {
  description: "Render a .tpl file, or render all .tpl files under a directory",
  summary: "Render template(s)",
  positionals: {
    target: {
      type: "string",
      description: "Template file or directory. Defaults to current directory when omitted",
      required: false,
    },
  },
  options: {
    data: {
      alias: "d",
      type: "string",
      description:
        "Optional data file (.toml or .json). Defaults to dottpl.toml/dottpl.json in current working directory",
    },
  },
  handler: async (argv) => {
    const outputBase = path.resolve(process.env.INIT_CWD ?? process.cwd());
    const target = typeof argv.target === "string" ? argv.target : undefined;
    const data = typeof argv.data === "string" ? argv.data : undefined;
    const results = renderTarget(target, data);

    for (const result of results) {
      const from = path.relative(outputBase, result.templatePath) || result.templatePath;
      const to = path.relative(outputBase, result.outputPath) || result.outputPath;
      console.log(`${from} -> ${to}`);
    }

    console.log(`rendered ${results.length} templates`);
  },
};

function main() {
  const def: CliDef = {
    name: "dottpl",
    description: "Render dotfile templates",
    commands: {
      render,
    },
  };

  build(def).parse();
}

main();
