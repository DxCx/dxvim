require('hex').setup()

local which_key = require("which-key")
which_key.register({
	["<F8>"] = { "<cmd>:HexToggle<cr>", "Hex Mode" },
}, { mode = "n", silent = true })
