import { lstatSync, realpathSync } from "fs";
import { table, defaultTheme as t } from "@spader/zargs";
import type { Config, Entry } from "./config";

export type Status = "ok" | "ready" | "symlink" | "file" | "dir" | "error";

export type Result = {
  name: string;
  target: string;
  status: Status;
  detail?: string;
};

const statusColor: Record<Status, (s: string) => string> = {
  ok:      t.success,
  ready:   t.link,
  symlink: t.error,
  file:    t.error,
  dir:     t.error,
  error:   t.error,
};

export function check(entry: Entry): Result {
  const { name, source, target } = entry;

  try {
    const stat = lstatSync(target);
    if (stat.isSymbolicLink()) {
      const linkTarget = realpathSync(target);
      if (linkTarget.toLowerCase() === source.toLowerCase()) {
        return { name, target, status: "ok" };
      }
      return { name, target, status: "symlink" };
    }
    if (stat.isDirectory()) {
      return { name, target, status: "dir" };
    }
    return { name, target, status: "file" };
  } catch {
    return { name, target, status: "ready" };
  }
}

export function printResults(results: Result[]): void {
  const names: string[] = [];
  const targets: string[] = [];
  const statuses: string[] = [];

  for (const r of results) {
    names.push(r.name);
    targets.push(r.target);
    statuses.push(r.detail ? `${r.status} (${r.detail})` : r.status);
  }

  table(
    ["program", "destination", "status"],
    [names, targets, statuses],
    {
      truncate: ["none", "start", "none"],
      format: [
        undefined!,
        (s) => t.dim(s),
        (s, row) => statusColor[results[row]!.status]!(s),
      ],
    },
  );
}

export function printStatus(config: Config): void {
  printResults(config.map(check));
}
