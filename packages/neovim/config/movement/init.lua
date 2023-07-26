local which_key = require("which-key")
local hop = require("hop")

hop.setup()

which_key.register({
	["<leader>"] = {
		C = {
			"<cmd>HopChar2<cr>",
			"Hop To Characters"
		},
		l = {
			"<cmd>HopLineStart<cr>",
			"Hop To Line Start"
		},
		L = {
			"<cmd>HopLine<cr>",
			"Hop To Line"
		},
		p = {
			"<cmd>HopPattern<cr>",
			"Hop To Pattern"
		},
		a = {
			"<cmd>HopAnywhere<cr>",
			"Hop Anywhere"
		},
		v = {
			"<cmd>HopVertical<cr>",
			"Hop Vertically"
		},
	},
	b = {
		"<cmd>HopWordBC<cr>",
		"Hop To Previous Word"
	},
	w = {
		"<cmd>HopWordAC<cr>",
		"Hop To Next Word"
	},
	W = {
		"<cmd>HopWord<cr>",
		"Hop To Word"
	}
}, {
	mode = "n",
	silent = true,
})
