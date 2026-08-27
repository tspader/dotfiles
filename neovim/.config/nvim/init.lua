---@diagnostic disable-next-line: undefined-global
local vim = vim or {}
local theme = require("theme")

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
-- vim.g.clipboard = 'osc52'
vim.opt.clipboard = 'unnamedplus'
vim.opt.fileformat = "unix"
vim.opt.cursorline = true
vim.opt.autoread = true
vim.opt.updatetime = 250
vim.opt.signcolumn = 'yes'
vim.opt.swapfile = false
vim.opt.fillchars:append("diff: ")
vim.diagnostic.config({
  signs = true,
  underline = true,
  virtual_text = true,
  update_in_insert = false,
})


vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "FocusGained" }, {
  command = "if mode() != 'c' | checktime | endif",
  pattern = { "*" },
})

-- Trim trailing whitespace on save. Extremely useful.
vim.api.nvim_create_autocmd("BufWritePre", {
 pattern = "*",
 callback = function()
   local view = vim.fn.winsaveview()
   vim.cmd([[keeppatterns %s/\s\+$//e]])
   vim.fn.winrestview(view)
 end
})

vim.filetype.add({
  extension = {
    c = "c",
    h = "c",
    mdx = "markdown",
    dsc = "typescript",
  }
})

vim.g.mapleader = " "


-- A couple helpers to make defining keybindings read a bit more naturally
-- instead of magic numbers and keys everywhere
VIM_MODE_NORMAL = 'n'

local leader = function(c)
  return '<leader>' .. c
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
      'axkirillov/unified.nvim',
      cmd = 'Unified',
      opts = {
        -- your configuration comes here
      },
      keys = {
        { leader('ud'), function() require('unified').toggle() end,                    desc = 'Toggle unified diff' },
        { ']h',         function() require('unified.navigation').next_hunk() end,      desc = 'Unified: Next hunk' },
        { '[h',         function() require('unified.navigation').previous_hunk() end,  desc = 'Unified: Previous hunk' },
        { 'gs',         function() require('unified.hunk_actions').stage_hunk() end,   desc = 'Unified: Stage hunk' },
        { 'gu',         function() require('unified.hunk_actions').unstage_hunk() end, desc = 'Unified: Unstage hunk' },
        { 'gr',         function() require('unified.hunk_actions').revert_hunk() end,  desc = 'Unified: Revert hunk' },
      },
      config = function(_, opts)
        require('unified').setup(opts)
      end,
    },
    {
      'tspader/friends.nvim',
      opts = {}
    },
    {
      'stevearc/overseer.nvim',
      opts = {},
      keys = {
        { leader('or'), function() vim.cmd('OverseerRun') end,    desc = 'Run task' },
        { leader('ot'), function() vim.cmd('OverseerToggle') end, desc = 'Toggle task list' },
      },
    },

    {
      "mikavilpas/yazi.nvim",
      event = "VeryLazy",
      dependencies = {
        { "nvim-lua/plenary.nvim", lazy = true },
      },
      keys = {
        { leader('fo'), function() vim.cmd('Yazi') end },
        { leader('fr'), function() vim.cmd('Yazi cwd') end },
        { leader('ft'), function() vim.cmd('Yazi toggle') end },
      },
      opts = {
        open_for_directories = false,
        keymaps = {
          show_help = "<f1>",
        },
      },
      init = function()
        -- mark netrw as loaded so it's not loaded at all.
        --
        -- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
        vim.g.loaded_netrwPlugin = 1
      end,
    },

    {
      "chentoast/marks.nvim",
      event = "VeryLazy",
      opts = {},
    },

    {
      'sindrets/diffview.nvim',
      opts = function()
        return {
          diff_binaries = false,
          use_icons = true,
          view = {
            default = {
              layout = "diff2_horizontal",  -- side by side
            },
          },
          file_history_panel = {
            win_config = {
              position = "left",
              width = 45,
            },
          },
          keymaps = {
            file_history_panel = {
              { "n", leader('gs'), require('diffview.actions').open_in_diffview,
                { desc = "Open entry in new Diffview" } },
            },
          },
        }
      end,
      keys = {
        { leader('gf'), function() vim.cmd('DiffviewToggleFiles') end, mode = { VIM_MODE_NORMAL } },
        { leader('go'), function() vim.cmd('DiffviewOpen') end, mode = { VIM_MODE_NORMAL } },
        { leader('gc'), function() vim.cmd('DiffviewClose') end, mode = { VIM_MODE_NORMAL } },
        { leader('gh'), function() vim.cmd('DiffviewFileHistory') end, mode = { VIM_MODE_NORMAL } },
        { leader('gr'), function() vim.cmd('DiffviewOpen HEAD~1..HEAD') end, mode = { VIM_MODE_NORMAL } },
      }
    },

    {
      'neovim/nvim-lspconfig',
      config = function()
        vim.lsp.config('*', {
          capabilities = require('blink.cmp').get_lsp_capabilities(),
        })

        vim.lsp.enable('rust_analyzer')
        vim.lsp.enable('clangd')
        vim.lsp.enable('ty')
        vim.lsp.enable('ruff')
        vim.lsp.enable('lua_ls')
        vim.lsp.enable('tsc')
        vim.lsp.enable('sourcekit')
        vim.lsp.enable('zls')
        vim.lsp.enable('gopls')
      end
    },

    {
      'saghen/blink.cmp',
      version = '1.*',
      dependencies = {
        'rafamadriz/friendly-snippets'
      },
      opts = {
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
          implementation = "prefer_rust"
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
        fadelevel = 0.75,
        tint = {
          bg = {
            rgb = {0, 0, 0},
            intensity = 0.25
          }
        }
      },
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
      "lukas-reineke/indent-blankline.nvim",
      main = "ibl",
      opts = {},
    },

    {
      "LunarVim/darkplus.nvim",
      config = function()
        vim.cmd.colorscheme("darkplus")

        local overrides = {
          { id = 'TelescopeNormal', values = { bg = theme.background }},
          { id = 'TelescopePromptNormal', values = { bg = theme.background }},
          { id = 'TelescopeResultsNormal', values = { bg = theme.background }},
          { id = 'TelescopePreviewNormal', values = { bg = theme.background }},
          { id = 'TelescopeBorder', values = { bg = theme.background, fg = theme.border }},
          { id = 'TelescopePromptBorder', values = { bg = theme.background, fg = theme.border }},
        }
        for override in vim.iter(overrides) do
          vim.api.nvim_set_hl(0, override.id, override.values)
        end
       end
    },

    {
      'nvim-lualine/lualine.nvim',
      dependencies = {
        'nvim-tree/nvim-web-devicons'
      },
      config = function()
        require('lualine').setup({
          tabline = {
            lualine_a = {{ 'tabs', mode = 1 }},
          },
          sections = {
            lualine_x = { 'friends', 'encoding', 'fileformat', 'filetype' },
          },
        })
      end
    },

    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
    },

    {
      "nvim-telescope/telescope.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "jmacadie/telescope-hierarchy.nvim",
        "nvim-telescope/telescope-ui-select.nvim"
      },
      opts = {
        defaults = {
          prompt_title = false,
          results_title = false,
          dynamic_preview_title = true,
          layout_strategy = 'vertical',
          layout_config = {
            vertical = {
              width = 0.95,
              height = 0.95,
              preview_cutoff = 0,
              prompt_position = "bottom",
            }
          },
        },
        pickers = {
          find_files = {
            follow = true
          },
        },
        extensions = {
          hierarchy = {
            initial_multi_expand = true,
            multi_depth = 1,
            layout_strategy = 'vertical',
            layout_config = {
              vertical = {
                width = 0.95,
                height = 0.95,
                preview_cutoff = 0,
                prompt_position = "bottom",
              }
            },
          }
        }
      },
      config = function(_, opts)
        opts.extensions["ui-select"] = {
          require("telescope.themes").get_dropdown({
            layout_config = { width = 0.7, height = 0.6 },
          }),
        }

        require('telescope').setup(opts)
        require('telescope').load_extension('fzf')
        require('telescope').load_extension('ui-select')
        local hierarchy = require("telescope").load_extension("hierarchy")

        local builtin = require('telescope.builtin')

        local ff = {
          'rg',
          '--iglob', '!.git',
          '--hidden',
          '--follow', '--files', '--trim', '--smart-case'
        }
        local fF = {}
        for _, value in pairs(ff) do
          table.insert(fF, value)
        end
        table.insert(fF, '--no-ignore')

        vim.keymap.set('n', leader('ff'), function() builtin.find_files({ find_command = ff }) end)
        vim.keymap.set('n', leader('fF'), function() builtin.find_files({ find_command = fF }) end)
        vim.keymap.set('n', leader('fg'), builtin.live_grep)
        vim.keymap.set('n', leader('fG'), function() builtin.live_grep { additional_args = { '--hidden', '--no-ignore' } } end)
        vim.keymap.set('n', leader('fs'), function() builtin.live_grep({ search_dirs = {vim.fn.expand('%:p')} }) end)
        vim.keymap.set('n', leader('fb'), function() builtin.buffers({ sort_mru  = true, ignore_current_buffer = true }) end)
        vim.keymap.set('n', leader('fh'), builtin.help_tags)
        vim.keymap.set('n', leader('fz'), builtin.current_buffer_fuzzy_find)
        vim.keymap.set('n', leader('fc'), function() builtin.find_files({ cwd = vim.fn.expand('%:p:h') }) end)

        vim.keymap.set('n', leader('li'), hierarchy.incoming_calls)
        vim.keymap.set('n', leader('lo'), hierarchy.outgoing_calls)
        vim.keymap.set('n', leader('ld'), builtin.lsp_definitions)
        vim.keymap.set('n', leader('lt'), builtin.lsp_type_definitions)
        vim.keymap.set('n', leader('lr'), function() builtin.lsp_references({ initial_mode = 'normal' }) end)
        vim.keymap.set('n', leader('lc'), builtin.lsp_implementations)
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
          builtin.diagnostics({
            initial_mode = 'normal',
            severity = vim.diagnostic.severity.ERROR,
            layout_strategy = 'vertical',
            layout_config = {
              width = 0.6,
              preview_cutoff = 0,
            },
          })
        end)
        vim.keymap.set('n', leader('lw'), function()
          require('telescope.builtin').diagnostics({
            severity = vim.diagnostic.severity.WARNING
          })
        end)
      end
    },
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      branch = "main",
      lazy = false,
      config = function()
        local ts = require("nvim-treesitter")

        local available = {}
        for _, lang in ipairs(ts.get_available()) do
          available[lang] = true
        end

        local installed = {}
        for _, lang in ipairs(ts.get_installed()) do
          installed[lang] = true
        end

        local function ensure(lang)
          if not lang or installed[lang] or not available[lang] then
            return
          end
          installed[lang] = true
          vim.schedule(function()
            ts.install(lang):await(function()
              vim.schedule(function()
                for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                  if vim.api.nvim_buf_is_loaded(buf) then
                    if vim.treesitter.highlighter.active[buf] then
                      vim.treesitter.stop(buf)
                      vim.treesitter.start(buf)
                    elseif vim.treesitter.language.get_lang(vim.bo[buf].filetype) == lang then
                      pcall(vim.treesitter.start, buf)
                    end
                  end
                end
              end)
            end)
          end)
        end

        -- Monkey patch language.add(), which is how injected languages (e.g.
        -- Markdown code fences) resolve their parser
        local add = vim.treesitter.language.add
        vim.treesitter.language.add = function(lang, opts)
          ensure(lang)
          return add(lang, opts)
        end

        vim.api.nvim_create_autocmd("FileType", {
          callback = function(args)
            local lang = vim.treesitter.language.get_lang(args.match)
            if not (lang and available[lang]) then
              return
            end
            ensure(lang)
            pcall(vim.treesitter.start, args.buf, lang)
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end,
        })
      end
    },

    {
      "kdheepak/lazygit.nvim",
      keys = {
        { leader('gg'), function() vim.cmd('LazyGit') end, mode = { VIM_MODE_NORMAL } }
      },
    }
  },
  checker = {
    enabled = true
  },
})

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    require("lazy").sync({ show = false })
  end,
})

vim.cmd([[
  highlight! link CursorLineNr Type
]])

