-- Minimal Neovim configuration with custom key bindings

-- Use M-d to toggle between insert and normal mode
vim.keymap.set('i', '<M-d>', '<Esc>', { noremap = true })  -- exit insert mode
vim.keymap.set('n', '<M-d>', 'a', { noremap = true })      -- enter insert mode (append)

-- Character movement (in normal mode) - ijkl
vim.keymap.set('n', 'i', 'k', { noremap = true })  -- up-char
vim.keymap.set('n', 'j', 'h', { noremap = true })  -- left-char
vim.keymap.set('n', 'k', 'j', { noremap = true })  -- down-char
vim.keymap.set('n', 'l', 'l', { noremap = true })  -- right-char

-- Line movement
vim.keymap.set('n', 'a', '0', { noremap = true })  -- line-start
vim.keymap.set('n', 'e', '$', { noremap = true })  -- line-end

-- Search and replace
vim.keymap.set('n', 'q', ':%s/', { noremap = true })  -- query-replace
vim.keymap.set('n', 'r', '?', { noremap = true })     -- search-backward
vim.keymap.set('n', 's', '/', { noremap = true })     -- search-forward

-- File operations
vim.keymap.set('n', 'w', ':q<CR>', { noremap = true })       -- close
vim.keymap.set('n', 'xo', ':e ', { noremap = true })         -- open-file
vim.keymap.set('n', 'xs', ':wa<CR>', { noremap = true })     -- save-files
vim.keymap.set('n', 'xS', ':w<CR>', { noremap = true })      -- save-file
vim.keymap.set('n', 'xg', ':', { noremap = true })           -- jump-line (use :N)
vim.keymap.set('n', 'xn', ':enew<CR>', { noremap = true })   -- new-file
vim.keymap.set('n', 'xr', ':f ', { noremap = true })         -- rename-file

-- Editing
vim.keymap.set('n', 'z', 'u', { noremap = true })         -- undo
vim.keymap.set('n', 'c', 'y', { noremap = true })         -- copy (yank)
vim.keymap.set('n', 'v', 'p', { noremap = true })         -- paste
vim.keymap.set('n', 'xx', 'd', { noremap = true })        -- cut (delete)
vim.keymap.set('n', 'xh', 'ggVG', { noremap = true })     -- select-all

-- Visual mode (marking)
vim.keymap.set('n', '<Space>', 'v', { noremap = true })   -- set-mark (enter visual mode)

-- Code navigation
vim.keymap.set('n', 'f', 'gd', { noremap = true })       -- peek-definition (go to definition)

-- Word/block movement (Meta/Alt key)
vim.keymap.set('n', '<M-<>', 'gg', { noremap = true })  -- file-start
vim.keymap.set('n', '<M->>', 'G', { noremap = true })   -- file-end
vim.keymap.set('n', '<M-i>', '{', { noremap = true })   -- up-block
vim.keymap.set('n', '<M-j>', 'b', { noremap = true })   -- left-word (backward)
vim.keymap.set('n', '<M-k>', '}', { noremap = true })   -- down-block
vim.keymap.set('n', '<M-l>', 'w', { noremap = true })   -- right-word (forward)

-- Visual mode mappings (ijkl movement keys work in visual mode)
vim.keymap.set('v', 'i', 'k', { noremap = true })
vim.keymap.set('v', 'j', 'h', { noremap = true })
vim.keymap.set('v', 'k', 'j', { noremap = true })
vim.keymap.set('v', 'l', 'l', { noremap = true })
vim.keymap.set('v', 'c', 'y', { noremap = true })      -- copy in visual mode
vim.keymap.set('v', 'xx', 'd', { noremap = true })     -- cut in visual mode

-- Basic settings
vim.opt.number = true          -- Show line numbers
vim.opt.relativenumber = true  -- Show relative line numbers
vim.opt.expandtab = true       -- Use spaces instead of tabs
vim.opt.shiftwidth = 2         -- Indent by 2 spaces
vim.opt.tabstop = 2            -- Tab width is 2 spaces
