-- ██╗      █████╗ ███████╗██╗   ██╗
-- ██║     ██╔══██╗╚══███╔╝╚██╗ ██╔╝
-- ██║     ███████║  ███╔╝  ╚████╔╝
-- ██║     ██╔══██║ ███╔╝    ╚██╔╝
-- ███████╗██║  ██║███████╗   ██║
-- ╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)


-- ███████╗███████╗████████╗████████╗██╗███╗   ██╗ ██████╗ ███████╗
-- ██╔════╝██╔════╝╚══██╔══╝╚══██╔══╝██║████╗  ██║██╔════╝ ██╔════╝
-- ███████╗█████╗     ██║      ██║   ██║██╔██╗ ██║██║  ███╗███████╗
-- ╚════██║██╔══╝     ██║      ██║   ██║██║╚██╗██║██║   ██║╚════██║
-- ███████║███████╗   ██║      ██║   ██║██║ ╚████║╚██████╔╝███████║
-- ╚══════╝╚══════╝   ╚═╝      ╚═╝   ╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚══════╝
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.scrolloff = 8
vim.opt.clipboard = 'unnamedplus'
vim.opt.fileformat = "unix"
vim.opt.cursorline = true
vim.opt.autoread = true
vim.opt.updatetime = 250
vim.opt.signcolumn = 'yes'
vim.diagnostic.config({
  signs = true,
  underline = true,
  virtual_text = true,
  update_in_insert = true,
})

vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "CursorMoved", "CursorMovedI", "FocusGained" }, {
  command = "if mode() != 'c' | checktime | endif",
  pattern = { "*" },
})

vim.api.nvim_create_autocmd("BufWritePre", {
 pattern = "*",
 callback = function()
   vim.cmd([[%s/\s\+$//e]])
 end
})

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"


-- ██╗  ██╗███████╗██╗   ██╗██████╗ ██╗███╗   ██╗██████╗ ██╗███╗   ██╗ ██████╗ ███████╗
-- ██║ ██╔╝██╔════╝╚██╗ ██╔╝██╔══██╗██║████╗  ██║██╔══██╗██║████╗  ██║██╔════╝ ██╔════╝
-- █████╔╝ █████╗   ╚████╔╝ ██████╔╝██║██╔██╗ ██║██║  ██║██║██╔██╗ ██║██║  ███╗███████╗
-- ██╔═██╗ ██╔══╝    ╚██╔╝  ██╔══██╗██║██║╚██╗██║██║  ██║██║██║╚██╗██║██║   ██║╚════██║
-- ██║  ██╗███████╗   ██║   ██████╔╝██║██║ ╚████║██████╔╝██║██║ ╚████║╚██████╔╝███████║
-- ╚═╝  ╚═╝╚══════╝   ╚═╝   ╚═════╝ ╚═╝╚═╝  ╚═══╝╚═════╝ ╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚══════╝
VIM_MODE_NORMAL = 'n'
VIM_MODE_VISUAL = 'v'

function leader(c)
  return '<leader>' .. c
end

function command(chord_key, command_key)
  return string.format('<C-%s>%s', chord_key, command_key)
end

vim.keymap.set(VIM_MODE_NORMAL, leader('rc'), function()
  vim.cmd('e ' .. vim.fn.stdpath('config') .. '/init.lua')
end)


-- ██████╗ ██╗     ██╗   ██╗ ██████╗ ██╗███╗   ██╗███████╗
-- ██╔══██╗██║     ██║   ██║██╔════╝ ██║████╗  ██║██╔════╝
-- ██████╔╝██║     ██║   ██║██║  ███╗██║██╔██╗ ██║███████╗
-- ██╔═══╝ ██║     ██║   ██║██║   ██║██║██║╚██╗██║╚════██║
-- ██║     ███████╗╚██████╔╝╚██████╔╝██║██║ ╚████║███████║
-- ╚═╝     ╚══════╝ ╚═════╝  ╚═════╝ ╚═╝╚═╝  ╚═══╝╚══════╝
require("lazy").setup({
  spec = {
    {
      'neovim/nvim-lspconfig',
      config = function()
        vim.lsp.enable('clangd')
        vim.lsp.enable('ty')
        vim.lsp.enable('ruff')
      end
    },

    {
      'saghen/blink.cmp',
      version = '1.*',
      dependencies = {
        'rafamadriz/friendly-snippets'
      },
      opts = {
        -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
        -- 'super-tab' for mappings similar to vscode (tab to accept)
        -- 'enter' for enter to accept
        -- 'none' for no mappings
        --
        -- All presets have the following mappings:
        -- C-space: Open menu or open docs if already open
        -- C-n/C-p or Up/Down: Select next/previous item
        -- C-e: Hide menu
        -- C-k: Toggle signature help (if signature.enabled = true)
        --
        -- See :h blink-cmp-config-keymap for defining your own keymap
        keymap = {
          preset = 'super-tab'
        },
        appearance = {
          nerd_font_variant = 'mono'
        },
        completion = {
          documentation = {
            auto_show = false
          }
        },
        sources = {
          default = { 'lsp', 'path', 'snippets', 'buffer' },
        },
        fuzzy = {
          implementation = "prefer_rust_with_warning"
        },
        signature = {
          enabled = true,
          trigger = {
            enabled = false
          }
        }
      },
      opts_extend = { "sources.default" }
    },

    {
      'TaDaa/vimade',
      opts = {
        enablefocusfading = true,
        ncmode = 'buffers',
        fadelevel = 0.7
      },
    },

    {
      'echasnovski/mini.tabline',
      version = '*',
      config = function()
        require('mini.tabline').setup({
          show_icons = true,
          set_vim_settings = true,
          tabpage_section = 'right'
        })
      end
    },

    {
      'echasnovski/mini.bufremove',
      version = '*',
      keys = {
        { leader('fd'), function() require('mini.bufremove').delete() end, mode = { VIM_MODE_NORMAL } }
      },
      config = function()
        require('mini.bufremove').setup()
      end
    },

    {
      'windwp/nvim-autopairs',
      event = "InsertEnter",
      config = function()
        require('nvim-autopairs').setup({
          check_ts = true,
          fast_wrap = {},
        })
      end
    },

    {
      'NickvanDyke/opencode.nvim',
      dependencies = {
        'folke/snacks.nvim',
      },
      opts = {},
      keys = {
        { leader('ct'), function() require('opencode').toggle() end, mode = { VIM_MODE_NORMAL } },
        { leader('cc'), function() require('opencode').ask() end,    mode = { VIM_MODE_NORMAL } },
      },
    },

    {
      'stevearc/oil.nvim',
      opts = {
        watch_for_changes = true,
        skip_confirm_for_simple_edits = true,
        constrain_cursor = 'editable',
        columns = {
          'size',
          'mtime',
        },
        view_options = {
          show_hidden = true,
          sort = {
            { "type", "asc" },
            { "name", "asc" }
          }
        },
        float = {
          padding = 2,
          max_width = 80,
          max_height = 30,
          border = 'rounded'
        },
        keymaps = {
          ["<Tab>"] = { "actions.preview" },
          ["<CR>"]  = { "actions.select" },
          ["vs"]    = { "actions.select_vsplit" },
          ["sp"]    = { "actions.select_split" },
          ["h"]     = { "actions.toggle_hidden" },
        }
      },
      dependencies = {
        "echasnovski/mini.icons",
      },
      keys = {
        { leader('fo'), function() require('oil').open_float() end, mode = { VIM_MODE_NORMAL } },
      },
      lazy = false,
    },

    {
      "lukas-reineke/indent-blankline.nvim",
      main = "ibl",
      opts = {},
    },

    {
      "LunarVim/darkplus.nvim",
      config = function()
        vim.cmd.colorscheme("darkplus")

        vim.cmd([[
          highlight TelescopeNormal guibg=#161616
          highlight TelescopeBorder guibg=#161616 guifg=#161616
          highlight TelescopePromptNormal guibg=#161616
          highlight TelescopePromptBorder guibg=#161616 guifg=#161616
          highlight TelescopeResultsNormal guibg=#161616
          highlight TelescopePreviewNormal guibg=#161616
        ]])

        vim.cmd([[
          highlight TreesitterContext guibg=#262626
          highlight TreesitterContextLineNumber guifg=#569cd6
          highlight TreesitterContextBottom gui=underline guisp=#3a3a3a
        ]])
       end
    },

    {
      'nvim-lualine/lualine.nvim',
      dependencies = {
        'nvim-tree/nvim-web-devicons'
      },
      config = function()
        require('lualine').setup()
      end
    },

    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make'
    },

{
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',  -- UI for debugging
    'nvim-neotest/nvim-nio', -- dependency for dap-ui
  },
  config = function()
    local dap = require('dap')
    local dapui = require('dapui')

    -- Setup UI
    dapui.setup()

    -- C/C++ with gdb
    dap.adapters.gdb = {
      type = "executable",
      command = "gdb",
      args = { "-i", "dap" }  -- requires gdb 14+
    }

dap.configurations.c = {
  {
    name = "Debug (make)",
    type = "gdb",
    request = "launch",
    program = function()
      vim.cmd('!make')  -- or whatever target builds debug
      return vim.fn.input('Executable: ', './build/bin', 'file')
    end,
    cwd = "${workspaceFolder}",
    stopAtBeginningOfMainSubprogram = true,
  },
}

    -- Keymaps
    vim.keymap.set('n', leader('dc'), dap.continue)
    vim.keymap.set('n', leader('ds'), dap.step_over)
    vim.keymap.set('n', leader('di'), dap.step_into)
    vim.keymap.set('n', leader('do'), dap.step_out)
    vim.keymap.set('n', leader('db'), dap.toggle_breakpoint)
    vim.keymap.set('n', leader('do'), dap.repl.open)
    vim.keymap.set({'n', 'v'}, '<Leader>dh', function()
      require('dap.ui.widgets').hover()
    end)
    vim.keymap.set({'n', 'v'}, '<Leader>dp', function()
      require('dap.ui.widgets').preview()
    end)
    vim.keymap.set('n', '<Leader>df', function()
      local widgets = require('dap.ui.widgets')
      widgets.centered_float(widgets.frames)
    end)
    vim.keymap.set('n', '<Leader>ds', function()
      local widgets = require('dap.ui.widgets')
      widgets.centered_float(widgets.scopes)
    end)

    -- Auto open/close UI
    dap.listeners.after.event_initialized["dapui_config"] = dapui.open
    dap.listeners.before.event_terminated["dapui_config"] = dapui.close
  end
},


    {
      "nvim-telescope/telescope.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim"
      },
      opts = {
        defaults = {
          prompt_title = false,
          results_title = false,
          dynamic_preview_title = true
        },
        pickers = {
          find_files = {
            follow = true
          },
        }
      },
      config = function(_, opts)
        require('telescope').setup(opts)

        local builtin = require('telescope.builtin')
        local pickers = require('telescope.pickers')
        local finders = require('telescope.finders')
        local actions = require('telescope.actions')

        local ff = {
          'rg',
          '--iglob', '!.git',
          '--hidden',
          '--follow', '--files', '--trim', '--smart-case'
        }
        local fF = {}
        for index, arg in pairs(ff) do table.insert(fF, arg) end
        table.insert(fF, '--no-ignore')

        vim.keymap.set('n', leader('ff'), function() builtin.find_files({ find_command = ff }) end)
        vim.keymap.set('n', leader('fF'), function() builtin.find_files({ find_command = fF }) end)
        vim.keymap.set('n', leader('fg'), builtin.live_grep)
        vim.keymap.set('n', leader('fG'), function() builtin.live_grep { additional_args = { '--hidden', '--no-ignore' } } end)
        vim.keymap.set('n', leader('fb'), function() builtin.buffers({ sort_mru  = true, ignore_current_buffer = true }) end)
        vim.keymap.set('n', leader('fh'), builtin.help_tags)
        vim.keymap.set('n', leader('fs'), builtin.current_buffer_fuzzy_find)
        vim.keymap.set('n', leader('fc'), function() builtin.find_files({ cwd = vim.fn.expand('%:p:h') }) end)

        vim.keymap.set('n', leader('ld'), builtin.lsp_definitions)
        vim.keymap.set('n', leader('lt'), builtin.lsp_type_definitions)
        vim.keymap.set('n', leader('lr'), builtin.lsp_references)
        vim.keymap.set('n', leader('lc'), builtin.lsp_implementations)
        vim.keymap.set('n', leader('li'), builtin.lsp_incoming_calls)
        vim.keymap.set('n', leader('lo'), builtin.lsp_outgoing_calls)
        vim.keymap.set('n', leader('lb'), builtin.diagnostics)
        vim.keymap.set('n', leader('lu'), vim.lsp.buf.rename)
        vim.keymap.set('n', leader('lf'), vim.lsp.buf.format)
        vim.keymap.set('n', leader('lg'), function() builtin.diagnostics({ bufnr = 0 }) end)
        vim.keymap.set('n', leader('lp'), function() builtin.lsp_definitions({ jump_type = 'never' }) end)
        vim.keymap.set('n', leader('lh'), function()
          local diag = vim.diagnostic.get(0, { lnum = vim.fn.line('.') - 1 })
          for _, d in ipairs(diag) do
            print("Code:", d.code, "Message:", d.message)
          end
        end)
        vim.keymap.set('n', leader('le'), function()
          require('telescope.builtin').diagnostics({
            severity = vim.diagnostic.severity.ERROR,
    layout_strategy = 'vertical',
    layout_config = {
      width = 0.6,
      preview_cutoff = 0,  -- always show preview
    },
          })
        end)
        vim.keymap.set('n', leader('lw'), function()
          require('telescope.builtin').diagnostics({
            severity = vim.diagnostic.severity.WARNING
          })
        end)

        vim.keymap.set('n', leader('mm'), function()
          local targets = {}
          local phonies = {}
          local makefile = io.open('Makefile', 'r')
          if not makefile then return end

          -- First pass: collect phony targets
          for line in makefile:lines() do
            local phony_match = line:match('^%.PHONY:%s*(.*)')
            if phony_match then
              for target in phony_match:gmatch('[%w_-]+') do
                phonies[target] = true
              end
            end
          end

          -- Second pass: get targets that are phony
          makefile:seek("set", 0)
          for line in makefile:lines() do
            local target = line:match('^([%w_-]+):')
            if target and phonies[target] then
              table.insert(targets, target)
            end
          end

          makefile:close()

          table.sort(targets)

          local picker = pickers.new({}, {
            prompt_title = 'Makefile',
            finder = finders.new_table {
              results = targets
            },
            sorter = require('telescope.config').values.generic_sorter({}),
            attach_mappings = function(buffer_index, map)
              require('telescope.actions').select_default:replace(function()
                require('telescope.actions').close(buffer_index)
                local selection = require('telescope.actions.state').get_selected_entry()
                vim.cmd('!make ' .. selection[1])
              end)
              return true
            end,
          })
          picker:find()
        end)
      end
    },

    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      config = function()
        require("nvim-treesitter.configs").setup({
          ensure_installed = {
            "c",
            "cpp",
            "lua",
            "python",
            "javascript",
            "typescript"
          },
          highlight = {
            enable = true
          },
          indent = {
            enable = true
          }
        })
      end
    },

    {
      'nvim-treesitter/nvim-treesitter-context',
      opts = {
        enable = true,
        max_lines = 4,
        patterns = {
          default = {
            'function',
            'while',
            'for',
            'if',
            'switch'
          },
          c = {
            'preproc_ifdef',
            'preproc_if',
            'preproc_elif',
            'preproc_else',
          }
        }
      }
    },

    {
      "kdheepak/lazygit.nvim",
      config = function()
        vim.keymap.set('n', '<leader>gg', ':LazyGit<CR>')
      end
    }
  },
  checker = {
    enabled = true
  },
})

vim.cmd([[
  highlight! link CursorLineNr Type
]])
