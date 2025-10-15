local wezterm = require("wezterm")

local config = {
  audible_bell = "Disabled",
  check_for_updates = false,
  color_scheme = "Dark+",
  inactive_pane_hsb = {
    hue = 1.0,
    saturation = 0.5,
    brightness = 0.75,
  },
  font_size = 12.0,
  enable_tab_bar = false,
  leader = { key="a", mods="ALT" },
  disable_default_key_bindings = true,
  launch_menu = {},
  keys = {
    { key = "c", mods = "LEADER", action = wezterm.action.SpawnTab "CurrentPaneDomain" },
    { key = "n", mods = "LEADER", action = wezterm.action.ActivateTabRelative(1) },
    { key = "p", mods = "LEADER", action = wezterm.action.ActivateTabRelative(-1) },
    { key = "s", mods = "LEADER", action = wezterm.action.SplitVertical { domain = "CurrentPaneDomain" } },
    { key = "v", mods = "LEADER", action = wezterm.action.SplitHorizontal { domain = "CurrentPaneDomain" } },
    { key = "o", mods = "LEADER", action = wezterm.action.ActivatePaneDirection "Next" },
    { key = ":", mods = "LEADER", action = wezterm.action.ActivateCommandPalette },
    { key = "?", mods = "LEADER", action = wezterm.action.ShowDebugOverlay },
    { key = "[", mods = "LEADER", action = wezterm.action.ActivateCopyMode },
    { key = "]", mods = "LEADER", action = wezterm.action.PasteFrom "Clipboard" },
    { key = "v", mods = "SHIFT|CTRL", action = wezterm.action.PasteFrom "Clipboard" },
    { key = "c", mods = "SHIFT|CTRL", action = wezterm.action.CopyTo "Clipboard" },
    { key = "+", mods = "SHIFT|CTRL", action = wezterm.action.IncreaseFontSize },
    { key = "-", mods = "SHIFT|CTRL", action = wezterm.action.DecreaseFontSize },
    { key = "0", mods = "SHIFT|CTRL", action = wezterm.action.ResetFontSize },
    { key = "n", mods = "SHIFT|CTRL", action = wezterm.action.ToggleFullScreen },
  },
  set_environment_variables = {},
}

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
  config.default_prog = { "pwsh.exe", "-NoLogo" }
end

return config
