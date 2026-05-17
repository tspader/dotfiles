# Halloy config.
#
# For a complete list of available options,
# please visit https://halloy.chat/configuration.html

theme = "dotfiles"

[actions.sidebar]
buffer = "replace-pane"

[font]
family = "{{ font.small.family }}"
size = {{ font.small.size }}

[servers.libera]
nickname = "spader"
server = "irc.libera.chat"
channels = ["#libera"]

[servers.libera.sasl.plain]
username = "spader"
password_command = "pass irc.libera.chat/spader"

