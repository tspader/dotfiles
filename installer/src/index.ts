#!/usr/bin/env bun

import { build, type Cli, type Command } from "@spader/zargs";
import { loadConfig } from "./config";
import { printStatus } from "./status";
import { link } from "./link";

const status: Command = {
  description: "Show symlink status for all entries",
  handler: async () => {
    const config = loadConfig();
    if (!config) return;
    printStatus(config);
  },
};

const linkCmd: Command = {
  description: "Symlink dotfiles to their OS-native locations (dry run by default)",
  options: {
    apply: {
      type: "boolean",
      description: "Actually create symlinks",
    },
    force: {
      alias: "f",
      type: "string",
      description: "Remove existing targets: 'unlink' (symlinks only) or 'delete' (everything)",
    },
  },
  handler: async (argv) => {
    const config = loadConfig();
    if (!config) return;
    const force = typeof argv.force === "string" ? argv.force as "unlink" | "delete" : undefined;
    if (force && force !== "unlink" && force !== "delete") {
      console.error(`invalid --force value: "${force}" (expected "unlink" or "delete")`);
      process.exit(1);
    }
    link(config, { apply: argv.apply === true, force });
  },
};

const def: Cli = {
  name: "installer",
  description: "Dotfiles installer for Windows",
  version: "0.1.0",
  commands: {
    status,
    link: linkCmd,
  },
};

build(def).parse();
