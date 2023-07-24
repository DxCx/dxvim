local function map(mode, lhs, rhs, opts)
	local options = { noremap = true }

	if opts then
		options = vim.tbl_extend("force", options, opts)
	end

	vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

local which_key = require("which-key")

which_key.register({
	["-"] =  { "<cmd>:set relativenumber!<cr>", "Toggle relativenumber" },
}, { mode = "n", silent = true })

which_key.register({
	s = { "<cmd>:set spell!<cr>", "Toggle spell checking" },
}, { mode = "n", silent = true, prefix = "<leader>" })

-- Exit terminal mode.
map("t", "<C-o>", "<C-\\><C-n>", { silent = true })
