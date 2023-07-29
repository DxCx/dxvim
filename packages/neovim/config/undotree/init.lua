local which_key = require("which-key")

which_key.register({
	u = {
		vim.cmd.UndotreeToggle, "Toggle UndoTree"
	},
}, { mode = "n", prefix = "<leader>", silent = true })
