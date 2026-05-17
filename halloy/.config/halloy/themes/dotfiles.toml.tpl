[general]
background = "{{ theme.background }}"
horizontal_rule = "{{ theme.border }}"
scrollbar = "{{ theme.border }}"
unread_indicator = "{{ theme.warning }}"
highlight_indicator = "{{ theme.accent }}"
border = "{{ theme.border }}"

[text]
primary = "{{ theme.foreground }}"
secondary = "{{ theme.foreground_secondary }}"
tertiary = "{{ theme.bright_magenta }}"
success = "{{ theme.green }}"
error = "{{ theme.critical }}"
warning = "{{ theme.warning }}"
info = "{{ theme.cyan }}"
debug = "{{ theme.bright_blue }}"
trace = "{{ theme.muted }}"

[buffer]
background = "{{ theme.background_dark }}"
background_text_input = "{{ theme.background_elevated }}"
background_title_bar = "{{ theme.background_elevated }}"
timestamp = "{{ theme.muted }}"
action = "{{ theme.green }}"
topic = "{{ theme.foreground_secondary }}"
highlight = "{{ theme.background_selected }}"
code = "{{ theme.bright_red }}"
nickname = "{{ theme.accent }}"
nickname_offline = "{{ theme.muted }}"
url = "{{ theme.bright_blue }}"
selection = "{{ theme.background_selected }}"
border_selected = "{{ theme.accent }}"

[buffer.server_messages]
default = "{{ theme.bright_yellow }}"

[buttons.primary]
background = "{{ theme.background_elevated }}"
background_hover = "{{ theme.background_selected }}"
background_selected = "{{ theme.background_status }}"
background_selected_hover = "{{ theme.border_inactive }}"

[buttons.secondary]
background = "{{ theme.background_dark }}"
background_hover = "{{ theme.background_elevated }}"
background_selected = "{{ theme.background_selected }}"
background_selected_hover = "{{ theme.background_status }}"

[formatting]
white = "{{ theme.white }}"
black = "{{ theme.black }}"
blue = "{{ theme.blue }}"
green = "{{ theme.green }}"
red = "{{ theme.red }}"
brown = "{{ theme.bright_red }}"
magenta = "{{ theme.magenta }}"
orange = "{{ theme.warning }}"
yellow = "{{ theme.yellow }}"
lightgreen = "{{ theme.bright_green }}"
cyan = "{{ theme.cyan }}"
lightcyan = "{{ theme.bright_cyan }}"
lightblue = "{{ theme.bright_blue }}"
pink = "{{ theme.bright_magenta }}"
grey = "{{ theme.muted }}"
lightgrey = "{{ theme.foreground_secondary }}"
