import json

filtered_keybindings = {
  'removed': [],
  'ctrl': [],
  'normal': []
}
with open('keybindings.json', 'r') as file:
  keybindings = json.load(file)
  print(f'{len(keybindings)} entries found in existing file')

  for keybinding in keybindings:


    if 'cmd' in keybinding['key']:
      pass
    elif keybinding['command'][0] == '-':
      filtered_keybindings['removed'].append(keybinding)
    elif 'ctrl' in keybinding['key']:
      filtered_keybindings['ctrl'].append(keybinding)
    else:
      filtered_keybindings['normal'].append(keybinding)

keybindings = []
for kind, filtered in filtered_keybindings.items():
  print(f'{kind} has {len(filtered)} entries')
  filtered.sort(key=lambda binding: binding['key'])
  keybindings += filtered

print(f'{len(keybindings)} entries processed')

with open('keybindings-filtered.json', 'w') as file:
  json.dump(keybindings, file, indent=2)