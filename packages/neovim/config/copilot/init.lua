local copilot = require('copilot')
local copilot_cmp = require("copilot_cmp")
local copilot_cmp_comparators = require("copilot_cmp.comparators")

copilot.setup({
	suggestion = { enabled = false },
	panel = { enabled = false },
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
