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

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("lazy").setup({
  spec = {
    {
      "LunarVim/darkplus.nvim",
      config = function()
        vim.cmd.colorscheme("darkplus")
      end
    }  
  },
  install = { 
    colorscheme = { 
      "habamax" 
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

vim.keymap.set(VIM_MODE_NORMAL, leader('a'),  'ggVG')
vim.keymap.set(VIM_MODE_NORMAL, leader('s'),  '/')
vim.keymap.set(VIM_MODE_NORMAL, leader('q'),  ':%s/')
vim.keymap.set(VIM_MODE_NORMAL, leader('fo'),  ':e')
vim.keymap.set(VIM_MODE_NORMAL, leader('xs'), ':wa<CR>')
vim.keymap.set(VIM_MODE_NORMAL, leader('xn'), ':enew<CR>')
vim.keymap.set(VIM_MODE_NORMAL, leader('g'),  ':')
vim.keymap.set({ VIM_MODE_NORMAL, VIM_MODE_VISUAL }, '<M-h>', '^') 
vim.keymap.set({ VIM_MODE_NORMAL, VIM_MODE_VISUAL }, '<M-l>', '$') 
vim.keymap.set({ VIM_MODE_NORMAL, VIM_MODE_VISUAL }, '<M-j>', '}') 
vim.keymap.set({ VIM_MODE_NORMAL, VIM_MODE_VISUAL }, '<M-k>', '{') 
