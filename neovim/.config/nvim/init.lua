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

vim.opt.number = true          -- Show line numbers
vim.opt.relativenumber = true  -- Show relative line numbers
vim.opt.expandtab = true       -- Use spaces instead of tabs
vim.opt.shiftwidth = 2         -- Indent by 2 spaces
vim.opt.tabstop = 2            -- Tab width is 2 spaces
vim.opt.softtabstop = 2            -- Tab width is 2 spaces
vim.opt.fillchars = { 
  vert = '│',
  horiz = '─',
}

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("lazy").setup({
  spec = {
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
        vim.keymap.set('n', '<M-p>', function()
          builtin.find_files({
            hidden = true
          })
        end)
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


VIM_MODE_NORMAL = 'n'
VIM_MODE_VISUAL = 'v'

function leader(c)
  return '<leader>' .. c
end

function command(chord_key, command_key)
  return string.format('<C-%s>%s', chord_key, command_key)
end

vim.keymap.set(VIM_MODE_NORMAL, leader('a'),  'ggVG')
vim.keymap.set(VIM_MODE_NORMAL, leader('s'),  '/')
vim.keymap.set(VIM_MODE_NORMAL, leader('r'),  '?')
vim.keymap.set(VIM_MODE_NORMAL, leader('q'),  ':%s/')
vim.keymap.set(VIM_MODE_NORMAL, leader('fo'),  ':e')
vim.keymap.set(VIM_MODE_NORMAL, leader('xs'), ':wa<CR>')
vim.keymap.set(VIM_MODE_NORMAL, leader('xn'), ':enew<CR>')
vim.keymap.set(VIM_MODE_NORMAL, leader('g'),  ':')
vim.keymap.set(VIM_MODE_NORMAL, '<M-h>',  command('w', 'h'))
vim.keymap.set(VIM_MODE_NORMAL, '<M-j>',  command('w', 'j'))
vim.keymap.set(VIM_MODE_NORMAL, '<M-k>',  command('w', 'k'))
vim.keymap.set(VIM_MODE_NORMAL, '<M-l>',  command('w', 'l'))
