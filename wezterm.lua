local wezterm = require("wezterm")
local config = wezterm.config_builder()
local action = wezterm.action

-- Set the leader key (equivalent to tmux prefix)
config.leader = { key = "s", mods = "CTRL", timeout_milliseconds = 2000 }

-- Pane navigation (equivalent to tmux pane movement)
local direction_keys = {
	h = "Left",
	j = "Down",
	k = "Up",
	l = "Right",
}

local function split_nav(key)
	return {
		key = key,
		mods = "CTRL",
		action = wezterm.action_callback(function(win, pane)
			if pane:get_user_vars().IS_NVIM == "true" then
				-- Send the keys to Neovim if it's active
				win:perform_action({
					SendKey = { key = key, mods = "CTRL" },
				}, pane)
			else
				win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
			end
		end),
	}
end

config.keys = {
	split_nav("h"),
	split_nav("j"),
	split_nav("k"),
	split_nav("l"),

	-- Window (tab) navigation
	{ key = "k", mods = "LEADER", action = action.ActivateTabRelative(1) },
	{ key = "j", mods = "LEADER", action = action.ActivateTabRelative(-1) },
	{ key = "l", mods = "LEADER", action = action.ActivateLastTab },

	-- Pane resizing (equivalent to tmux resize-pane)
	{ key = "h", mods = "CTRL|SHIFT", action = action.AdjustPaneSize({ "Left", 5 }) },
	{ key = "j", mods = "CTRL|SHIFT", action = action.AdjustPaneSize({ "Down", 5 }) },
	{ key = "k", mods = "CTRL|SHIFT", action = action.AdjustPaneSize({ "Up", 5 }) },
	{ key = "l", mods = "CTRL|SHIFT", action = action.AdjustPaneSize({ "Right", 5 }) },

	-- Copy Mode (like tmux copy-mode)
	{ key = "[", mods = "LEADER", action = action.ActivateCopyMode },

	-- Splitting panes
	{ key = "-", mods = "LEADER", action = action.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "\\", mods = "LEADER", action = action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },

	-- Zoom pane (like tmux's pane zoom)
	{ key = "m", mods = "LEADER", action = action.TogglePaneZoomState },
}

return config
