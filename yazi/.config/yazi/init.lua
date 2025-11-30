function Linemode:mtime_precise()
  local time = self._file.cha.mtime or 0
  if time == 0 then
    return ""
  end

  return os.date("%Y-%m-%d %H:%M:%S", math.floor(time))
end
