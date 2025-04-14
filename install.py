import os

appdata = os.getenv('APPDATA')

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
  }
}

dotfiles = os.path.normpath(os.path.dirname(os.path.abspath(__file__)))
vscode = os.path.normpath(os.path.join(dotfiles, 'vscode'))


def main():
  for program, program_map in symlinks.items():
    for target_file, link_path in program_map.items():
      target_path = os.path.normpath(os.path.join(dotfiles, program, target_file))
      link_path = os.path.normpath(os.path.join(link_path, target_file))

      print(f'Linking {target_path} -> {link_path}')

      if os.path.exists(link_path):
        os.remove(link_path)

      os.symlink(target_path, link_path)


if __name__ == '__main__':
  main()