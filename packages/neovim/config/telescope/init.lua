local which_key = require("which-key")
local telescope = require("telescope")
local api = require("telescope.builtin")

local is_in_git = function()
	local paths = vim.fs.find('.git', {
		limit = 1,
		upward = true,
		type = 'directory',
	})

	return #paths > 0
end

local find_files_ext = function()
	if (is_in_git()) then
		api.git_files()
	else
		api.find_files()
	end
end

telescope.setup {
	defaults = {
		mappings = {
			i = {
				["<C-h>"] = "which_key"
			},
		},
	},
	pickers = {
		-- Your special builtin config goes in here
		buffers = {
			sort_lastused = true,
			theme = "dropdown",
			previewer = true,
		},
		git_files = {
			show_untracked = false,
		}
	},
	extensions = {
		fzf = {
			fuzzy = true,           -- false will only do exact matching
			override_generic_sorter = false, -- override the generic sorter
			override_file_sorter = true, -- override the file sorter
			case_mode = "smart_case", -- or "ignore_case" or "respect_case"
			-- the default case_mode is "smart_case"
		}
	}
}

telescope.load_extension('fzf')

which_key.register({
	["<C-p>"] = {
		name = "Telescope Find",
		p = { find_files_ext, "Find File" },
		["<C-p>"] = { find_files_ext, "Find File" },
		r = { "<cmd>Telescope oldfiles<cr>", "Recent File" },
		g = { "<cmd>Telescope live_grep<cr>", "Grep" },
		G = { function()
			api.live_grep { hidden = true }
		end, "Grep (Hidden Files)" },
		b = { "<cmd>Telescope buffers<cr>", "Find Buffer" },
	},
}, { mode = "n", silent = true })
