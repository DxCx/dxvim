local navic = require('nvim-navic')

navic.setup {
	icons = {
		File          = "󰈙 ",
		Module        = " ",
		Namespace     = "󰌗 ",
		Package       = " ",
		Class         = "󰌗 ",
		Method        = "󰆧 ",
		Property      = " ",
		Field         = " ",
		Constructor   = " ",
		Enum          = "󰕘",
		Interface     = "󰕘",
		Function      = "󰊕 ",
		Variable      = "󰆧 ",
		Constant      = "󰏿 ",
		String        = "󰀬 ",
		Number        = "󰎠 ",
		Boolean       = "◩ ",
		Array         = "󰅪 ",
		Object        = "󰅩 ",
		Key           = "󰌋 ",
		Null          = "󰟢 ",
		EnumMember    = " ",
		Struct        = "󰌗 ",
		Event         = " ",
		Operator      = "󰆕 ",
		TypeParameter = "󰊄 ",
	},
	highlight = false,
	separator = " > ",
	depth_limit = 0,
	depth_limit_indicator = "..",
	safe_output = true
}

vim.cmd.dxvim.lsp_on_attach_hook(function(client, buffer)
	if client.server_capabilities.documentSymbolProvider then
		navic.attach(client, buffer)
	end
end)
