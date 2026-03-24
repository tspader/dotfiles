import { lstatSync, symlinkSync, mkdirSync, unlinkSync, rmSync } from "fs";
import { dirname } from "path";
import type { Config } from "./config";
import { check, printResults, type Result } from "./status";

function forceRemove(target: string, mode: "unlink" | "delete"): boolean {
  try {
    const stat = lstatSync(target);
    if (mode === "unlink") {
      if (!stat.isSymbolicLink()) return false;
      unlinkSync(target);
      return true;
    }
    // delete mode: remove whatever is there
    if (stat.isSymbolicLink()) {
      unlinkSync(target);
    } else if (stat.isDirectory()) {
      rmSync(target, { recursive: true });
    } else {
      unlinkSync(target);
    }
    return true;
  } catch {
    return false;
  }
}

function doLink(source: string, target: string): void {
  const dir = dirname(target);
  mkdirSync(dir, { recursive: true });

  const isDir = lstatSync(source).isDirectory();
  symlinkSync(source, target, isDir ? "junction" : "file");
}

export function link(
  config: Config,
  opts: { apply: boolean; force?: "unlink" | "delete" },
): void {
  const results: Result[] = [];

  for (const entry of config) {
    let result = check(entry);

    const blocked = result.status === "symlink" || result.status === "file" || result.status === "dir";
    if (opts.apply && blocked && opts.force) {
      if (forceRemove(entry.target, opts.force)) {
        result = check(entry);
      }
    }

    if (opts.apply && result.status === "ready") {
      try {
        doLink(entry.source, entry.target);
        result.status = "ok";
      } catch (err) {
        result.status = "error";
        result.detail = err instanceof Error ? err.message : String(err);
      }
    }

    results.push(result);
  }

  printResults(results);
}
