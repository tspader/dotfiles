[mgr]
cwd = { fg = "{{ theme.foreground }}" }
hovered = { fg = "{{ theme.foreground }}", bg = "{{ theme.blue }}", bold = true }
preview_hovered = { underline = true }
find_keyword = { fg = "{{ theme.bright_yellow }}", bold = true, italic = true }
find_position = { fg = "{{ theme.bright_red }}", bg = "reset", bold = true }
marker_copied = { fg = "{{ theme.green }}", bg = "{{ theme.green }}" }
marker_cut = { fg = "{{ theme.red }}", bg = "{{ theme.red }}" }
marker_marked = { fg = "{{ theme.yellow }}", bg = "{{ theme.yellow }}" }
marker_selected = { fg = "{{ theme.blue }}", bg = "{{ theme.blue }}" }
count_copied = { fg = "{{ theme.background }}", bg = "{{ theme.green }}" }
count_cut = { fg = "{{ theme.background }}", bg = "{{ theme.red }}" }
count_selected = { fg = "{{ theme.background }}", bg = "{{ theme.blue }}" }
border_style = { fg = "{{ theme.muted }}" }

[tabs]
active = { fg = "{{ theme.foreground }}", bg = "{{ theme.blue }}" }
inactive = { fg = "{{ theme.muted }}", bg = "{{ theme.black }}" }
sep_inner = { open = "", close = "" }
sep_outer = { open = " ", close = " " }

[mode]
normal_main = { fg = "{{ theme.background }}", bg = "{{ theme.blue }}", bold = true }
normal_alt = { fg = "{{ theme.blue }}", bg = "{{ theme.black }}" }
select_main = { fg = "{{ theme.background }}", bg = "{{ theme.green }}", bold = true }
select_alt = { fg = "{{ theme.green }}", bg = "{{ theme.black }}" }
unset_main = { fg = "{{ theme.background }}", bg = "{{ theme.red }}", bold = true }
unset_alt = { fg = "{{ theme.red }}", bg = "{{ theme.black }}" }

[status]
overall = { fg = "{{ theme.foreground }}", bg = "{{ theme.black }}" }
sep_left = { open = "", close = "" }
sep_right = { open = "", close = "" }
perm_type = { fg = "{{ theme.blue }}" }
perm_read = { fg = "{{ theme.green }}" }
perm_write = { fg = "{{ theme.yellow }}" }
perm_exec = { fg = "{{ theme.red }}" }
perm_sep = { fg = "{{ theme.muted }}" }
progress_label = { fg = "{{ theme.foreground }}", bold = true }
progress_normal = { fg = "{{ theme.blue }}", bg = "{{ theme.blue }}" }
progress_error = { fg = "{{ theme.red }}", bg = "{{ theme.red }}" }

[which]
cols = 3
mask = { bg = "{{ theme.black }}" }
cand = { fg = "{{ theme.blue }}", bg = "{{ theme.black }}", bold = true }
rest = { fg = "{{ theme.muted }}" }
desc = { fg = "{{ theme.foreground }}" }
separator = "  "
separator_style = { fg = "{{ theme.muted }}" }

[confirm]
border = { fg = "{{ theme.blue }}" }
title = { fg = "{{ theme.foreground }}", bold = true }
content = { fg = "{{ theme.foreground_bright }}" }
list = { fg = "{{ theme.foreground }}" }
btn_yes = { fg = "{{ theme.background }}", bg = "{{ theme.green }}", bold = true }
btn_no = { fg = "{{ theme.background }}", bg = "{{ theme.red }}", bold = true }
btn_labels = ["Y", "N"]

[spot]
border = { fg = "{{ theme.blue }}" }
title = { fg = "{{ theme.foreground }}", bold = true }
tbl_col = { fg = "{{ theme.blue }}", bold = true }
tbl_cell = { fg = "{{ theme.foreground }}" }

[notify]
title_info = { fg = "{{ theme.blue }}", bold = true }
title_warn = { fg = "{{ theme.yellow }}", bold = true }
title_error = { fg = "{{ theme.red }}", bold = true }

[pick]
border = { fg = "{{ theme.blue }}" }
active = { fg = "{{ theme.background }}", bg = "{{ theme.blue }}", bold = true }
inactive = { fg = "{{ theme.foreground }}" }

[input]
border = { fg = "{{ theme.blue }}" }
title = { fg = "{{ theme.foreground }}", bold = true }
value = { fg = "{{ theme.foreground_bright }}" }
selected = { fg = "{{ theme.background }}", bg = "{{ theme.blue }}", bold = true }

[cmp]
border = { fg = "{{ theme.blue }}" }
active = { fg = "{{ theme.background }}", bg = "{{ theme.blue }}", bold = true }
inactive = { fg = "{{ theme.foreground }}" }

[tasks]
border = { fg = "{{ theme.blue }}" }
title = { fg = "{{ theme.foreground }}", bold = true }
hovered = { fg = "{{ theme.background }}", bg = "{{ theme.blue }}", bold = true }

[help]
on = { fg = "{{ theme.blue }}" }
run = { fg = "{{ theme.green }}" }
desc = { fg = "{{ theme.muted }}" }
hovered = { fg = "{{ theme.background }}", bg = "{{ theme.blue }}", bold = true }
footer = { fg = "{{ theme.muted }}" }

[filetype]
rules = [
	{ mime = "image/*", fg = "{{ theme.yellow }}" },
	{ mime = "video/*", fg = "{{ theme.cyan }}" },
	{ mime = "audio/*", fg = "{{ theme.cyan }}" },
	{ mime = "application/zip", fg = "{{ theme.red }}" },
	{ mime = "application/gzip", fg = "{{ theme.red }}" },
	{ mime = "application/x-tar", fg = "{{ theme.red }}" },
	{ mime = "application/x-bzip2", fg = "{{ theme.red }}" },
	{ mime = "application/x-7z-compressed", fg = "{{ theme.red }}" },
	{ mime = "application/x-rar", fg = "{{ theme.red }}" },
	{ mime = "application/pdf", fg = "{{ theme.red }}" },
	{ name = "*.sh", fg = "{{ theme.green }}" },
	{ name = "*.bash", fg = "{{ theme.green }}" },
	{ name = "*.zsh", fg = "{{ theme.green }}" },
	{ name = "*.fish", fg = "{{ theme.green }}" },
	{ name = "*.py", fg = "{{ theme.cyan }}" },
	{ name = "*.js", fg = "{{ theme.bright_yellow }}" },
	{ name = "*.ts", fg = "{{ theme.bright_red }}" },
	{ name = "*.rs", fg = "{{ theme.bright_red }}" },
	{ name = "*.c", fg = "{{ theme.cyan }}" },
	{ name = "*.cpp", fg = "{{ theme.cyan }}" },
	{ name = "*.java", fg = "{{ theme.red }}" },
	{ name = "*.go", fg = "{{ theme.green }}" },
	{ name = "*.rb", fg = "{{ theme.red }}" },
	{ name = "*.php", fg = "{{ theme.cyan }}" },
	{ name = "*.swift", fg = "{{ theme.bright_red }}" },
	{ name = "*.kt", fg = "{{ theme.red }}" },
	{ name = "*.scala", fg = "{{ theme.red }}" },
	{ name = "*.hs", fg = "{{ theme.cyan }}" },
	{ name = "*.ml", fg = "{{ theme.bright_red }}" },
	{ name = "*.lua", fg = "{{ theme.green }}" },
	{ name = "*.pl", fg = "{{ theme.cyan }}" },
	{ name = "*.r", fg = "{{ theme.green }}" },
	{ name = "*.sql", fg = "{{ theme.yellow }}" },
	{ name = "*.html", fg = "{{ theme.yellow }}" },
	{ name = "*.css", fg = "{{ theme.blue }}" },
	{ name = "*.scss", fg = "{{ theme.bright_red }}" },
	{ name = "*.sass", fg = "{{ theme.bright_red }}" },
	{ name = "*.less", fg = "{{ theme.bright_red }}" },
	{ name = "*.xml", fg = "{{ theme.yellow }}" },
	{ name = "*.json", fg = "{{ theme.bright_red }}" },
	{ name = "*.yaml", fg = "{{ theme.green }}" },
	{ name = "*.yml", fg = "{{ theme.green }}" },
	{ name = "*.toml", fg = "{{ theme.green }}" },
	{ name = "*.ini", fg = "{{ theme.muted }}" },
	{ name = "*.conf", fg = "{{ theme.muted }}" },
	{ name = "*.cfg", fg = "{{ theme.muted }}" },
	{ name = "*.md", fg = "{{ theme.foreground_bright }}" },
	{ name = "*.txt", fg = "{{ theme.foreground_bright }}" },
	{ name = "*.log", fg = "{{ theme.muted }}" },
	{ name = "*.dockerfile", fg = "{{ theme.cyan }}" },
	{ name = "Dockerfile", fg = "{{ theme.cyan }}" },
	{ name = "Makefile", fg = "{{ theme.yellow }}" },
	{ name = "*.mk", fg = "{{ theme.yellow }}" },
	{ name = "*.cmake", fg = "{{ theme.red }}" },
	{ name = "CMakeLists.txt", fg = "{{ theme.red }}" },
	{ name = "*.gradle", fg = "{{ theme.green }}" },
	{ name = "*.vue", fg = "{{ theme.cyan }}" },
	{ name = "*.svelte", fg = "{{ theme.bright_red }}" },
	{ name = "*.jsx", fg = "{{ theme.bright_yellow }}" },
	{ name = "*.tsx", fg = "{{ theme.bright_red }}" },
	{ name = "*", is = "orphan", fg = "{{ theme.red }}" },
	{ name = "*", is = "link", fg = "{{ theme.cyan }}" },
	{ name = "*", is = "exec", fg = "{{ theme.green }}" },
	{ name = "*/", fg = "{{ theme.blue }}" },
	{ mime = "text/*", fg = "{{ theme.foreground_bright }}" },
	{ mime = "inode/empty", fg = "{{ theme.muted }}" }
]
