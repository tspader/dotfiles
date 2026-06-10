--- @sync entry
return {
	entry = function()
		local cur = cx.active.pref.linemode
		ya.emit("linemode", { cur == "none" and "mtime_precise" or "none" })
	end,
}
