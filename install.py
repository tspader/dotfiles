import os
import subprocess
import argparse

from typing import List

appdata = os.getenv('APPDATA')
caret = '-> '

symlinks = {
  'bash': {
    '.bashrc': os.path.expanduser('~'),
    '.profile': os.path.expanduser('~')
  },
  'vscode': {
    'keybindings.json': os.path.join(appdata, 'Code', 'User'),
    'settings.json': os.path.join(appdata, 'Code', 'User')
  },
  'cmd.exe': {
    '.cmd.bat': os.path.expanduser('~'),
  },
  'powershell': {
    'profile.ps1': os.path.dirname(subprocess.run(["powershell.exe", "-Command", "$profile"], capture_output=True, text=True).stdout.strip())
  }
}

dotfiles = os.path.normpath(os.path.dirname(os.path.abspath(__file__)))
vscode = os.path.normpath(os.path.join(dotfiles, 'vscode'))

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
  for program, program_map in symlinks.items():
    for target_file, link_path in program_map.items():
      target_path = os.path.normpath(os.path.join(dotfiles, program, target_file))
      link_path = os.path.normpath(os.path.join(link_path, target_file))
      print(f'Linking {target_path} -> {link_path}')

      if os.path.islink(link_path):
        if force:
          print(f'{caret}Link already exists at link path, but it will be unlinked because of --force')
          unlink.append(UnlinkItem(link_path))
          link.append(LinkItem(target_path, link_path))
          print(f'{caret}Link already exists at link path, skipping.')
      else:
          print(f'{caret}Link does not exist at path; adding.')
          link.append(LinkItem(target_path, link_path))

  if not dry_run:
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
  args = parser.parse_args()
  main(args.dry_run, args.force)