import argparse
import json
import platform
import os
import subprocess

from typing import List

dotfiles = os.path.normpath(os.path.dirname(os.path.abspath(__file__)))

if platform.system() == 'Windows':
  local_appdata = os.getenv('LOCALAPPDATA')
  appdata = os.getenv('APPDATA')
  home = os.getenv('USERPROFILE')
  config = os.path.join(home, '.config')
  powershell = os.path.join(home, 'Documents', 'WindowsPowerShell', 'Modules')
  profile = os.path.dirname(subprocess.run(["pwsh.exe", "-Command", "$PROFILE.CurrentUserAllHosts"], capture_output=True, text=True).stdout.strip())

  symlinks = {
    'bash': {
      '.bashrc': home,
      '.profile': home,
    },
    'cmd.exe': {
      '.cmd.bat': home,
    },
    'powershell': {
      'profile.ps1': profile,
    },
    'wezterm': {
      '.config/wezterm': config,
    },
    'neovim': {
      '.config/nvim': appdata
    },
    'alacritty': {
      '.config/alacritty': appdata
    }
  }

  functions = []
else:
  symlinks = {
    'macos': {
      'com.local.LaunchAgent.plist': os.path.join(os.getenv('HOME'), 'Library', 'LaunchAgents')
    }
  }

  functions = [build_macos_vscode]

class UnlinkItem():
  def __init__(self, target):
    self.target = target

class LinkItem():
  def __init__(self, target, link):
    self.target = target
    self.link = link

unlink: List[UnlinkItem] = []
link: List[LinkItem] = []

def main(dry_run = False, force = False):
  print(f'Building for {platform.system()}')
  for program, program_map in symlinks.items():
    for target_file, link_path in program_map.items():
      target_path = os.path.normpath(os.path.join(dotfiles, program, target_file))
      link_path = os.path.normpath(os.path.join(link_path, os.path.basename(target_file)))

      if os.path.islink(link_path):
        if force:
          print(f'Force linking {target_path} -> {link_path}')
          unlink.append(UnlinkItem(link_path))
          link.append(LinkItem(target_path, link_path))
        else:
          print(f'Skipping {target_path} -> {link_path}')
      else:
          print(f'Linking {target_path} -> {link_path}')
          link.append(LinkItem(target_path, link_path))

  if not dry_run:
    for function in functions:
      function()

    for item in unlink:
      os.unlink(item.target)

    for item in link:
      link_dir = os.path.dirname(item.link)
      os.makedirs(link_dir, exist_ok=True)
      os.symlink(item.target, item.link)

if __name__ == '__main__':
  parser = argparse.ArgumentParser(description='A tool for symlinking dotfiles')
  parser.add_argument('--dry-run', required=False, help='Do not actually perform file operations', action='store_true', default=False)
  parser.add_argument('--force', required=False, help='Delete existing links and re-link', action='store_true', default=False)
  parser.add_argument('--folder', required=False, help='Specify a single folder to link', type=str, default=None)
  args = parser.parse_args()

  # Check if folder exists in symlinks
  if args.folder and args.folder not in symlinks:
    print(f"Error: '{args.folder}' is not a valid folder option.")
    print(f"Available options: {', '.join(symlinks.keys())}")
    exit(1)

  # Build list of items to process
  items_to_process = []
  if args.folder:
    items_to_process.append((args.folder, symlinks[args.folder]))
  else:
    items_to_process = list(symlinks.items())

  main(args.dry_run, args.force)
