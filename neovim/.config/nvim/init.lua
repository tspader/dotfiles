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
vim.opt.fillchars = { 
  vert = '│',
  horiz = '─',
}
vim.opt.cursorline = true
vim.o.autoread = true
vim.o.updatetime = 250
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "CursorMoved", "CursorMovedI", "FocusGained" }, {
  command = "if mode() != 'c' | checktime | endif",
  pattern = { "*" },
})
vim.opt.iskeyword:remove({ '_', '-' })

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
      'MeanderingProgrammer/render-markdown.nvim',
      dependencies = { 
        'nvim-treesitter/nvim-treesitter',
        'echasnovski/mini.icons' 
      },
      opts = {
        completions = {
          lsp = {
            enabled = true
          }
        }
      },
    },
    {
      'echasnovski/mini.bufremove',
      version = '*',
      keys = {
        { leader('fd'), function() require('mini.bufremove').unshow() end, mode = { VIM_MODE_NORMAL } }
      },
      config = function() 
        require('mini.bufremove').setup()
      end
    },
    {
      'echasnovski/mini.pairs',
      version = '*',
      config = function() 
        require('mini.pairs').setup()
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
      "greggh/claude-code.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim"
      },
      config = function()
        require("claude-code").setup()
      end
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
      dependencies = {"nvim-lua/plenary.nvim"},
      config = function()
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', leader('ff'), function() builtin.find_files({ find_command = {'rg', '--files', '--iglob', '!.git', '--hidden'} }) end)
        vim.keymap.set('n', leader('fg'), builtin.live_grep)
        vim.keymap.set('n', leader('fb'), builtin.buffers)
        vim.keymap.set('n', leader('fh'), builtin.help_tags)
        vim.keymap.set('n', leader('fr'), builtin.oldfiles)
        vim.keymap.set('n', '<leader>fc', function()
          require('telescope.builtin').find_files({ cwd = vim.fn.expand('%:p:h') })
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
