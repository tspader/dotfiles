--- Open the hovered (or selected) files in a persistent Neovim pane that zellij
--- splits off to the right of yazi, and collapse yazi's preview column to make
--- room for it. The Neovim instance is reused for subsequent files.

local NAME = "zellij-nvim"

local function sock()
	local dir = os.getenv("XDG_RUNTIME_DIR") or "/tmp"
	local sess = os.getenv("ZELLIJ_SESSION_NAME") or "solo"
	local pane = os.getenv("ZELLIJ_PANE_ID") or "0"
	return string.format("%s/yazi-nvim-%s-%s.sock", dir, sess, pane)
end

local function fail(content)
	ya.notify { title = NAME, content = content, level = "error", timeout = 5 }
end

local targets = ya.sync(function()
	local urls = {}
	for _, u in pairs(cx.active.selected) do
		urls[#urls + 1] = tostring(u)
	end
	if #urls == 0 and cx.active.current.hovered then
		urls[1] = tostring(cx.active.current.hovered.url)
	end
	return { urls = urls, cwd = tostring(cx.active.current.cwd) }
end)

local pane_get = ya.sync(function(st) return st.pane end)
local pane_set = ya.sync(function(st, id) st.pane = id end)

local collapse = ya.sync(function(st)
	local r = rt.mgr.ratio
	if r[3] > 0 then
		st.ratio = { r[1], r[2], r[3] }
		rt.mgr.ratio = { r[1], r[2], 0 }
		ui.render()
	end
end)

local restore = ya.sync(function(st)
	if st.ratio then
		rt.mgr.ratio = st.ratio
		st.ratio = nil
		ui.render()
	end
end)

local toggle = ya.sync(function(st)
	local r = rt.mgr.ratio
	if r[3] > 0 then
		st.ratio = { r[1], r[2], r[3] }
		rt.mgr.ratio = { r[1], r[2], 0 }
	else
		rt.mgr.ratio = st.ratio or { 1, 4, 3 }
		st.ratio = nil
	end
	ui.render()
end)

-- `nvim --remote` silently falls back to editing locally when the server is
-- gone, so probe with `--remote-expr`, which fails instead.
local function alive(s)
	local status = Command("nvim"):arg { "--server", s, "--remote-expr", "1" }:status()
	return status and status.success
end

local function zellij(args)
	local out, err = Command("zellij"):arg(args):output()
	if not out then
		return nil, tostring(err)
	elseif not out.status.success then
		return nil, out.stderr
	end
	return (out.stdout:gsub("%s+$", ""))
end

local function spawn(s, cwd, urls)
	local args = {
		"action", "new-pane",
		"--direction", "right",
		"--name", "nvim",
		"--close-on-exit",
		"--cwd", cwd,
		"--", "nvim", "--listen", s,
	}
	for _, u in ipairs(urls) do
		args[#args + 1] = u
	end
	return zellij(args)
end

local function open()
	if not os.getenv("ZELLIJ") then
		return fail("Not running inside zellij")
	end

	local t = targets()
	if #t.urls == 0 then
		return
	end

	local s = sock()
	collapse()

	if alive(s) then
		local args = { "--server", s, "--remote" }
		for _, u in ipairs(t.urls) do
			args[#args + 1] = u
		end
		Command("nvim"):arg(args):status()

		-- The pane id is lost when yazi restarts, but the nvim it spawned may
		-- well outlive it; fall back to whatever sits to our right
		local id = pane_get()
		if id then
			zellij { "action", "focus-pane-id", id }
		else
			zellij { "action", "move-focus", "right" }
		end
		return
	end

	fs.remove("file", Url(s)) -- A stale socket would stop nvim from binding
	local id, err = spawn(s, t.cwd, t.urls)
	if not id then
		restore()
		return fail("Failed to open the nvim pane: " .. tostring(err))
	end
	pane_set(id)
end

local function close()
	local s = sock()
	if not alive(s) then
		pane_set(nil)
		return restore()
	end

	Command("nvim"):arg { "--server", s, "--remote-send", "<C-\\><C-n>:qa<CR>" }:status()

	-- nvim unlinks its socket on exit, so that's the cheapest liveness signal
	for _ = 1, 20 do
		ya.sleep(0.1)
		if not fs.cha(Url(s)) then
			pane_set(nil)
			return restore()
		end
	end
	fail("Neovim didn't quit — unsaved changes?")
end

return {
	entry = function(_, job)
		local action = job.args[1] or "open"
		if action == "open" then
			open()
		elseif action == "close" then
			close()
		elseif action == "toggle-preview" then
			toggle()
		else
			fail("Unknown action: " .. tostring(action))
		end
	end,
}
