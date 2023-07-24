local home = os.getenv("HOME")
local dashboard = require("dashboard")
local dbsession = require("dbsession")

local footer = {
	"",
	""
}

local header = {
	"",
	""
}

dashboard.setup {
	theme = "hyper",
	disable_move = true,
	change_to_vcs_root = true,
	hide = {
		statusline = true,
		tabline = true,
		winbar = true,
	},
	config = {
		header = header,
		footer = footer,
		week_header = {
			enable = false,
		},
		packages = {
			-- I manage packages with Nix :)
			enable = false,
		},
		project = {
			enable = true,
			icon = "󰉋 ",
			label = "Projects",
			limit = 8,
			action = "e ",
		},
		mru = {
			label = "Recent Files",
			limit = 10,
			action = "e ",
		},
		shortcut = {
			{
				icon = " ",
				desc = "Open File",
				key = "f",
				group = "Label",
				action = "Telescope find_files",
			},
			{
				icon = " ",
				desc = "Open Recent",
				key = "r",
				group = "Label",
				action = "Telescope oldfiles",
			},
			{
				icon = " ",
				desc = "Open Config",
				key = "c",
				group = "DiagnosticHint",
				action = "e " .. home .. "/work/config",
			},
		},
	},
}

dbsession.setup {
	dir = home .. "/.config/dashboard-nvim",
	auto_save_on_exit = true,
}
