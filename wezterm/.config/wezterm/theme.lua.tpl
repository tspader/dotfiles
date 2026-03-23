return {
  font_family = "{{ font.family }}",
  font_size = {{ font.size }},
  colors = {
    foreground = "{{ theme.foreground }}",
    background = "{{ theme.background }}",
    ansi = {
      "{{ theme.black }}",
      "{{ theme.red }}",
      "{{ theme.green }}",
      "{{ theme.yellow }}",
      "{{ theme.blue }}",
      "{{ theme.magenta }}",
      "{{ theme.cyan }}",
      "{{ theme.white }}",
    },
    brights = {
      "{{ theme.bright_black }}",
      "{{ theme.bright_red }}",
      "{{ theme.bright_green }}",
      "{{ theme.bright_yellow }}",
      "{{ theme.bright_blue }}",
      "{{ theme.bright_magenta }}",
      "{{ theme.bright_cyan }}",
      "{{ theme.bright_white }}",
    },
  },
}
