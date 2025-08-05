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

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true     
vim.opt.shiftwidth = 2       
vim.opt.tabstop = 2          
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

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("lazy").setup({
  spec = {
    {
      "greggh/claude-code.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim", -- Required for git operations
      },
      config = function()
        require("claude-code").setup()
      end
    },
    {
      'stevearc/oil.nvim',
      opts = {
        watch_for_changes = true,
        view_options = {
          show_hidden = true,
          sort = {
            { "type", "asc" },
            { "name", "asc" }
          }
        },
        keymaps = {
          ["<Tab>"] = "actions.preview",
          ["<CR>"] = "actions.select",
          ["vs"] = { "actions.select", opts = { vertical = true } },
          ["sp"] = { "actions.select", opts = { horizontal = true } },
          ["h"] = { "actions.toggle_hidden", mode = "n" },
        }
      },
      dependencies = {
        {
          "echasnovski/mini.icons",
          opts = {} 
        } 
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
        vim.cmd('highlight StatusLine guifg=#ffffff guibg=#444444')
        vim.cmd('highlight StatusLineNC guifg=#888888 guibg=#222222')
      end
    },
    {
      "nvim-telescope/telescope.nvim",
      dependencies = {"nvim-lua/plenary.nvim"},
      config = function()
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<M-p>', builtin.find_files)
        vim.keymap.set('n', '<M-f>', builtin.live_grep)
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
    }
  },
  checker = { 
    enabled = true 
  },
})

vim.cmd([[
  highlight! link CursorLineNr Type
]])

VIM_MODE_NORMAL = 'n'
VIM_MODE_VISUAL = 'v'

function leader(c)
  return '<leader>' .. c
end

function command(chord_key, command_key)
  return string.format('<C-%s>%s', chord_key, command_key)
end

vim.keymap.set(VIM_MODE_NORMAL, '<M-h>',      command('w', 'h'))
vim.keymap.set(VIM_MODE_NORMAL, '<M-j>',      command('w', 'j'))
vim.keymap.set(VIM_MODE_NORMAL, '<M-k>',      command('w', 'k'))
vim.keymap.set(VIM_MODE_NORMAL, '<M-l>',      command('w', 'l'))

vim.keymap.set('n', leader('rc'), function()
  vim.cmd('e ' .. vim.fn.stdpath('config') .. '/init.lua')
end)
