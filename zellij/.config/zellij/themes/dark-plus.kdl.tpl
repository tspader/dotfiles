themes {
    dark-plus {
        text_unselected {
            base {{ theme.foreground_bright | rgb }}
            emphasis_0 {{ theme.bright_red | rgb }}
            emphasis_1 {{ theme.cyan | rgb }}
            emphasis_2 {{ theme.green | rgb }}
            emphasis_3 {{ theme.magenta | rgb }}
            background {{ theme.black | rgb }}
        }
        text_selected {
            base {{ theme.foreground_bright | rgb }}
            emphasis_0 {{ theme.bright_red | rgb }}
            emphasis_1 {{ theme.cyan | rgb }}
            emphasis_2 {{ theme.green | rgb }}
            emphasis_3 {{ theme.magenta | rgb }}
            background {{ theme.background_selected | rgb }}
        }
        ribbon_unselected {
            base {{ theme.black | rgb }}
            emphasis_0 {{ theme.red | rgb }}
            emphasis_1 {{ theme.foreground_bright | rgb }}
            emphasis_2 {{ theme.blue | rgb }}
            emphasis_3 {{ theme.magenta | rgb }}
            background {{ theme.foreground | rgb }}
        }
        ribbon_selected {
            base {{ theme.black | rgb }}
            emphasis_0 {{ theme.red | rgb }}
            emphasis_1 {{ theme.bright_red | rgb }}
            emphasis_2 {{ theme.magenta | rgb }}
            emphasis_3 {{ theme.blue | rgb }}
            background {{ theme.green | rgb }}
        }
        exit_code_success {
            base {{ theme.green | rgb }}
            emphasis_0 {{ theme.cyan | rgb }}
            emphasis_1 {{ theme.black | rgb }}
            emphasis_2 {{ theme.magenta | rgb }}
            emphasis_3 {{ theme.blue | rgb }}
        }
        exit_code_error {
            base {{ theme.red | rgb }}
            emphasis_0 {{ theme.yellow | rgb }}
            emphasis_1 {{ theme.yellow | rgb }}
            emphasis_2 {{ theme.foreground_bright | rgb }}
            emphasis_3 {{ theme.magenta | rgb }}
        }
        frame_unselected {
            base "{{ theme.border_inactive }}"
            emphasis_0 "{{ theme.border_inactive }}"
            emphasis_1 "{{ theme.border_inactive }}"
            emphasis_2 "{{ theme.border_inactive }}"
            emphasis_3 "{{ theme.border_inactive }}"
        }
        frame_selected {
            base {{ theme.green | rgb }}
            emphasis_0 {{ theme.bright_red | rgb }}
            emphasis_1 {{ theme.cyan | rgb }}
            emphasis_2 {{ theme.magenta | rgb }}
            emphasis_3 {{ theme.magenta | rgb }}
        }
        frame_highlight {
            base {{ theme.bright_red | rgb }}
            emphasis_0 {{ theme.magenta | rgb }}
            emphasis_1 {{ theme.magenta | rgb }}
            emphasis_2 {{ theme.bright_red | rgb }}
            emphasis_3 {{ theme.bright_red | rgb }}
        }
        table_title {
            base {{ theme.green | rgb }}
            emphasis_0 {{ theme.bright_red | rgb }}
            emphasis_1 {{ theme.cyan | rgb }}
            emphasis_2 {{ theme.green | rgb }}
            emphasis_3 {{ theme.magenta | rgb }}
        }
        table_cell_unselected {
            base {{ theme.foreground_bright | rgb }}
            emphasis_0 {{ theme.bright_red | rgb }}
            emphasis_1 {{ theme.cyan | rgb }}
            emphasis_2 {{ theme.green | rgb }}
            emphasis_3 {{ theme.magenta | rgb }}
            background {{ theme.black | rgb }}
        }
        table_cell_selected {
            base {{ theme.black | rgb }}
            emphasis_0 {{ theme.red | rgb }}
            emphasis_1 {{ theme.bright_red | rgb }}
            emphasis_2 {{ theme.magenta | rgb }}
            emphasis_3 {{ theme.blue | rgb }}
            background {{ theme.green | rgb }}
        }
        list_unselected {
            base {{ theme.foreground_bright | rgb }}
            emphasis_0 {{ theme.bright_red | rgb }}
            emphasis_1 {{ theme.cyan | rgb }}
            emphasis_2 {{ theme.green | rgb }}
            emphasis_3 {{ theme.magenta | rgb }}
            background {{ theme.black | rgb }}
        }
        list_selected {
            base {{ theme.black | rgb }}
            emphasis_0 {{ theme.red | rgb }}
            emphasis_1 {{ theme.bright_red | rgb }}
            emphasis_2 {{ theme.magenta | rgb }}
            emphasis_3 {{ theme.blue | rgb }}
            background {{ theme.green | rgb }}
        }
    }
}
