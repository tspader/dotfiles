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
	{ url ="*.sh", fg = "{{ theme.green }}" },
	{ url ="*.bash", fg = "{{ theme.green }}" },
	{ url ="*.zsh", fg = "{{ theme.green }}" },
	{ url ="*.fish", fg = "{{ theme.green }}" },
	{ url ="*.py", fg = "{{ theme.cyan }}" },
	{ url ="*.js", fg = "{{ theme.bright_yellow }}" },
	{ url ="*.ts", fg = "{{ theme.bright_red }}" },
	{ url ="*.rs", fg = "{{ theme.bright_red }}" },
	{ url ="*.c", fg = "{{ theme.cyan }}" },
	{ url ="*.cpp", fg = "{{ theme.cyan }}" },
	{ url ="*.java", fg = "{{ theme.red }}" },
	{ url ="*.go", fg = "{{ theme.green }}" },
	{ url ="*.rb", fg = "{{ theme.red }}" },
	{ url ="*.php", fg = "{{ theme.cyan }}" },
	{ url ="*.swift", fg = "{{ theme.bright_red }}" },
	{ url ="*.kt", fg = "{{ theme.red }}" },
	{ url ="*.scala", fg = "{{ theme.red }}" },
	{ url ="*.hs", fg = "{{ theme.cyan }}" },
	{ url ="*.ml", fg = "{{ theme.bright_red }}" },
	{ url ="*.lua", fg = "{{ theme.green }}" },
	{ url ="*.pl", fg = "{{ theme.cyan }}" },
	{ url ="*.r", fg = "{{ theme.green }}" },
	{ url ="*.sql", fg = "{{ theme.yellow }}" },
	{ url ="*.html", fg = "{{ theme.yellow }}" },
	{ url ="*.css", fg = "{{ theme.blue }}" },
	{ url ="*.scss", fg = "{{ theme.bright_red }}" },
	{ url ="*.sass", fg = "{{ theme.bright_red }}" },
	{ url ="*.less", fg = "{{ theme.bright_red }}" },
	{ url ="*.xml", fg = "{{ theme.yellow }}" },
	{ url ="*.json", fg = "{{ theme.bright_red }}" },
	{ url ="*.yaml", fg = "{{ theme.green }}" },
	{ url ="*.yml", fg = "{{ theme.green }}" },
	{ url ="*.toml", fg = "{{ theme.green }}" },
	{ url ="*.ini", fg = "{{ theme.muted }}" },
	{ url ="*.conf", fg = "{{ theme.muted }}" },
	{ url ="*.cfg", fg = "{{ theme.muted }}" },
	{ url ="*.md", fg = "{{ theme.foreground_bright }}" },
	{ url ="*.txt", fg = "{{ theme.foreground_bright }}" },
	{ url ="*.log", fg = "{{ theme.muted }}" },
	{ url ="*.dockerfile", fg = "{{ theme.cyan }}" },
	{ url ="Dockerfile", fg = "{{ theme.cyan }}" },
	{ url ="Makefile", fg = "{{ theme.yellow }}" },
	{ url ="*.mk", fg = "{{ theme.yellow }}" },
	{ url ="*.cmake", fg = "{{ theme.red }}" },
	{ url ="CMakeLists.txt", fg = "{{ theme.red }}" },
	{ url ="*.gradle", fg = "{{ theme.green }}" },
	{ url ="*.vue", fg = "{{ theme.cyan }}" },
	{ url ="*.svelte", fg = "{{ theme.bright_red }}" },
	{ url ="*.jsx", fg = "{{ theme.bright_yellow }}" },
	{ url ="*.tsx", fg = "{{ theme.bright_red }}" },
	{ url ="*", is = "orphan", fg = "{{ theme.red }}" },
	{ url ="*", is = "link", fg = "{{ theme.cyan }}" },
	{ url ="*", is = "exec", fg = "{{ theme.green }}" },
	{ url ="*/", fg = "{{ theme.blue }}" },
	{ mime = "text/*", fg = "{{ theme.foreground_bright }}" },
	{ mime = "inode/empty", fg = "{{ theme.muted }}" }
]
