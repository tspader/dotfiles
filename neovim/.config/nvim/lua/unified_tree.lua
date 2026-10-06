-- Hierarchical sidebar for unified.nvim.
--
-- The plugin builds a real tree (nodes with children, parents, dirs-first sort)
-- but its renderer flattens it into groups keyed by an abbreviated parent path.
-- This replaces render_tree with a recursive walk. Safe to monkeypatch: every
-- call site looks the function up on the module table at call time.

local M = {}

-- Foreground-only status colours; the Diff* groups carry a background that
-- reads as a highlighted block in a narrow sidebar.
local STATUS = {
  A = { 'A', 'UnifiedTreeAdded', '#6a9955' },
  M = { 'M', 'UnifiedTreeModified', '#dcdcaa' },
  D = { 'D', 'UnifiedTreeDeleted', '#f44747' },
  R = { 'R', 'UnifiedTreeRenamed', '#569cd6' },
  C = { 'C', 'UnifiedTreeCached', '#808080' },
  ['?'] = { '?', 'UnifiedTreeUntracked', '#808080' },
}

local function define_highlights()
  for _, status in pairs(STATUS) do
    vim.api.nvim_set_hl(0, status[2], { fg = status[3] })
  end
end

function M.setup()
  define_highlights()
  vim.api.nvim_create_autocmd('ColorScheme', { callback = define_highlights })

  local render = require('unified.file_tree.render')
  local state = require('unified.file_tree.state')
  local ns = vim.api.nvim_create_namespace('unified_file_tree')

  local function has_change(node)
    if not node.is_dir then
      return (node.status or ' ') ~= ' '
    end
    for _, child in ipairs(node:get_children() or {}) do
      if has_change(child) then
        return true
      end
    end
    return false
  end

  render.render_tree = function(tree, buffer)
    buffer = buffer or vim.api.nvim_get_current_buf()
    vim.bo[buffer].modifiable = true
    vim.api.nvim_buf_clear_namespace(buffer, ns, 0, -1)
    state.line_to_node = {}
    state.expanded_dirs = state.expanded_dirs or {}

    local lines = { '  ' .. vim.fn.fnamemodify(tree.root.path, ':~'), '  Help: ? ', '' }
    local marks = {}
    local file_count = 0

    local function walk(node, depth)
      for _, child in ipairs(node:get_children() or {}) do
        if not state.diff_only or has_change(child) then
          local indent = string.rep('  ', depth)
          if child.is_dir then
            -- Directories default to expanded; expanded_dirs only records collapses.
            local open = state.expanded_dirs[child.path] ~= false
            lines[#lines + 1] = ' ' .. indent .. (open and '▾ ' or '▸ ') .. child.name
            local line = #lines - 1
            state.line_to_node[line] = child
            marks[#marks + 1] = { line = line, col = 1 + #indent, hl = 'Directory' }
            if open then
              walk(child, depth + 1)
            end
          else
            file_count = file_count + 1
            lines[#lines + 1] = ' ' .. indent .. '  ' .. child.name
            local line = #lines - 1
            state.line_to_node[line] = child
            local key = (child.status or ' '):match('[AMDRC?]')
            local status = key and STATUS[key]
            if status then
              marks[#marks + 1] = { line = line, col = 0, hl = status[2], virt = status[1] }
            end
          end
        end
      end
    end
    walk(tree.root, 0)

    if file_count == 0 then
      lines[#lines + 1] = '  No changes to display'
    end

    vim.api.nvim_buf_set_lines(buffer, 0, -1, false, lines)
    vim.api.nvim_buf_set_extmark(buffer, ns, 0, 0, { end_col = #lines[1], hl_group = 'Title' })
    vim.api.nvim_buf_set_extmark(buffer, ns, 1, 0, { end_col = #lines[2], hl_group = 'Comment' })
    for _, mark in ipairs(marks) do
      if mark.virt then
        vim.api.nvim_buf_set_extmark(buffer, ns, mark.line, mark.col, {
          virt_text = { { mark.virt, mark.hl } },
          virt_text_pos = 'overlay',
        })
      else
        vim.api.nvim_buf_set_extmark(buffer, ns, mark.line, mark.col, {
          end_col = #lines[mark.line + 1],
          hl_group = mark.hl,
        })
      end
    end

    vim.bo[buffer].modifiable = false
    state.buffer = buffer
    state.current_tree = tree
  end

  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'unified_tree',
    callback = function(ev)
      local function toggle()
        local line = vim.api.nvim_win_get_cursor(0)[1] - 1
        local node = state.line_to_node[line]
        if node and node.is_dir then
          state.expanded_dirs[node.path] = state.expanded_dirs[node.path] == false
          render.render_tree(state.current_tree, ev.buf)
          vim.api.nvim_win_set_cursor(0, { line + 1, 0 })
        else
          require('unified.file_tree.actions').toggle_node()
        end
      end

      for _, key in ipairs({ 'l', '<CR>', 'o' }) do
        vim.keymap.set('n', key, toggle, { buffer = ev.buf, silent = true })
      end

      -- The plugin remaps these to skip every line that isn't a file, which
      -- would make directory rows unreachable.
      for _, key in ipairs({ 'j', 'k', '<Down>', '<Up>' }) do
        pcall(vim.keymap.del, 'n', key, { buffer = ev.buf })
      end
    end,
  })
end

return M
