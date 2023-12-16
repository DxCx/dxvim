local copilot = require('copilot')
local copilot_cmp = require("copilot_cmp")
local copilot_cmp_comparators = require("copilot_cmp.comparators")
local which_key = require("which-key")

copilot.setup({
	suggestion = { enabled = false },
	panel = {
		enabled = true,
		auto_refresh = true,
		keymap = {
			jump_prev = "[[",
			jump_next = "]]",
			accept = "<CR>",
			refresh = "gr",
			open = "<M-CR>"
		},
		layout = {
			position = "bottom", -- | top | left | right
			ratio = 0.4
		},
	},
	filetypes = {
		gitcommit = true,
		markdown  = true,
		yaml      = true,
	}
})
copilot_cmp.setup()

vim.cmd.dxvim.update_lsp_cmp_setup({
	sorting = {
		comparators = {
			copilot_cmp_comparators.prioritize,
		},
	},
	sources = {
		{ name = "copilot", group_index = 2 },
	},
})

which_key.register({
	c = {
		name = "Code",
		c = { "<cmd>:Copilot panel<cr>", "Copilot suggest" },
	},
}, { mode = "n", prefix = "<leader>" })
