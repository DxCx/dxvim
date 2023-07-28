local which_key = require("which-key")
local maximizer = require("maximizer")

which_key.register({
	["<C-w>"] = {
		z = {
			maximizer.toggle,
			"Toggle Maximizer"
		},
	},
}, {
	mode = "n",
	silent = true,
})

vim.cmd.dxvim = vim.cmd.dxvim.table_merge(vim.cmd.dxvim, {
	is_maximized = function()
		return vim.t.is_maximized
	end,
})
