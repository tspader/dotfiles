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
vim.opt.iskeyword:remove({ '_', '-' })

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("lazy").setup({
  spec = {
    {
  'NickvanDyke/opencode.nvim',
  dependencies = { 'folke/snacks.nvim', },

  ---@type opencode.Config
  opts = {
    -- Your configuration, if any
  },
  keys = {
    { '<leader>ot', function() require('opencode').toggle() end, desc = 'Toggle embedded opencode', },
    { '<leader>oa', function() require('opencode').ask() end, desc = 'Ask opencode', mode = 'n', },
    { '<leader>oa', function() require('opencode').ask('@selection: ') end, desc = 'Ask opencode about selection', mode = 'v', },
    { '<leader>op', function() require('opencode').select_prompt() end, desc = 'Select prompt', mode = { 'n', 'v', }, },
    { '<leader>on', function() require('opencode').command('session_new') end, desc = 'New session', },
    { '<leader>oy', function() require('opencode').command('messages_copy') end, desc = 'Copy last message', },
    { '<S-C-u>',    function() require('opencode').command('messages_half_page_up') end, desc = 'Scroll messages up', },
    { '<S-C-d>',    function() require('opencode').command('messages_half_page_down') end, desc = 'Scroll messages down', },
  },
},
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

VIM_MODE_NORMAL = 'n'
VIM_MODE_VISUAL = 'v'

function leader(c)
  return '<leader>' .. c
end

function command(chord_key, command_key)
  return string.format('<C-%s>%s', chord_key, command_key)
end

vim.keymap.set({ VIM_MODE_NORMAL, VIM_MODE_VISUAL }, '<M-h>',      command('w', 'h'))
vim.keymap.set({ VIM_MODE_NORMAL, VIM_MODE_VISUAL }, '<M-j>',      command('w', 'j'))
vim.keymap.set({ VIM_MODE_NORMAL, VIM_MODE_VISUAL }, '<M-k>',      command('w', 'k'))
vim.keymap.set({ VIM_MODE_NORMAL, VIM_MODE_VISUAL }, '<M-l>',      command('w', 'l'))

vim.keymap.set('n', leader('rc'), function()
  vim.cmd('e ' .. vim.fn.stdpath('config') .. '/init.lua')
end)
