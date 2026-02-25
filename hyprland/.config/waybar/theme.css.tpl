@define-color accent        {{ theme.accent }};
@define-color main-br       alpha({{ theme.foreground }}, 0.70);
@define-color main-bg       shade({{ theme.background }}, 0.85);
@define-color main-fg       {{ theme.foreground }};
@define-color hover-bg      shade({{ theme.background }}, 1.10);
@define-color hover-fg      alpha(@main-fg, 0.75);
@define-color outline       shade(@main-bg, 0.5);

@define-color workspaces    shade({{ theme.background }}, 0.90);
@define-color temperature   shade({{ theme.background }}, 0.90);
@define-color memory        shade({{ theme.background }}, 1.00);
@define-color cpu           shade({{ theme.background }}, 1.10);
@define-color time          shade({{ theme.background }}, 1.10);
@define-color date          shade({{ theme.background }}, 1.00);
@define-color tray          shade({{ theme.background }}, 0.90);
@define-color volume        shade({{ theme.background }}, 0.90);
@define-color backlight     shade({{ theme.background }}, 1.00);
@define-color battery       shade({{ theme.background }}, 1.10);

@define-color warning       {{ theme.warning }};
@define-color critical      {{ theme.critical }};
@define-color charging      {{ theme.charging }};
