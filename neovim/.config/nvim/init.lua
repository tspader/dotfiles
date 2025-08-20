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
vim.opt.iskeyword:remove({ '_', '-' })
vim.opt.fillchars = {
  vert = '│',
  horiz = '─',
}

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

vim.keymap.set('n', leader('rc'), function()
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
    require('lspconfig').clangd.setup{}
  end
},

    {
      'TaDaa/vimade',
      tint = {
      },
      config = function()
        local Fade = require('vimade.style.fade').Fade
        local animate = require('vimade.style.value.animate')
        local ease = require('vimade.style.value.ease')

        require('vimade').setup{
          style = {
            Fade {
              value = animate.Number {
                start = 1,
                to = 0.4,
                duration = 10,
                ease = ease.OUT_CUBIC,
              }
            }
          }
        }
      end
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
          check_ts = true,  -- use treesitter to check for pairs
          fast_wrap = {},   -- Alt-e to fast wrap
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
      "nvim-telescope/telescope.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim"
      },
      opts = {
        pickers = {
          find_files = {
            follow = true
          }
        }
      },
      config = function()
        local builtin = require('telescope.builtin')
        local pickers = require('telescope.pickers')
        local finders = require('telescope.finders')
        local actions = require('telescope.actions')

        -- Files
        vim.keymap.set('n', leader('fg'), builtin.live_grep)
        vim.keymap.set('n', leader('fG'), function() builtin.live_grep { additional_args = { '--hidden', '--no-ignore' } } end)
        vim.keymap.set('n', leader('fb'), builtin.buffers)
        vim.keymap.set('n', leader('fh'), builtin.help_tags)
        vim.keymap.set('n', leader('fs'), builtin.current_buffer_fuzzy_find)
        vim.keymap.set('n', leader('fc'), function() builtin.find_files({ cwd = vim.fn.expand('%:p:h') }) end)
        vim.keymap.set('n', leader('ff'), function() builtin.find_files({ find_command = {'rg', '-L', '--files', '--iglob', '!.git', '--hidden'} }) end)

        -- LSP
        vim.keymap.set('n', leader('ld'), builtin.lsp_definitions)
        vim.keymap.set('n', leader('lt'), builtin.lsp_type_definitions)
        vim.keymap.set('n', leader('lr'), builtin.lsp_references)
        vim.keymap.set('n', leader('lc'), builtin.lsp_implementations)
        vim.keymap.set('n', leader('li'), builtin.lsp_incoming_calls)
        vim.keymap.set('n', leader('lo'), builtin.lsp_outgoing_calls)
        vim.keymap.set('n', leader('lb'), builtin.diagnostics)
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
            severity = vim.diagnostic.severity.ERROR
          })
        end)

        -- Makefile
        vim.keymap.set('n', leader('mm'), function()
          local targets = {}
          local makefile = io.open('Makefile', 'r')
          if not makefile then return end

          for line in makefile:lines() do
            local target = line:match('^([%w_-]+):')
            if target and not target:match('^%.') then
              table.insert(targets, target)
            end
          end

          makefile:close()

          local picker = pickers.new({}, {
            prompt_title = 'Makefile',
            finder = finders.new_table {
              results = targets
            },
            sorter = require('telescope.config').values.generic_sorter({

            }),
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
