local neodev = require("neodev")

neodev.setup {
	lspconfig = true,
	library = {
		enabled = true,
		plugins = true,
		runtime = true,
		types = true,
	},
}

vim.cmd.dxvim.enable_lsp("lua_ls", {
	lsp_cmp_setup = {
		sources = {
			{ name = 'nvim_lua', group_index = 2 }
		},
	},
	lsp_setup = {
		cmd = { "lua-language-server" },
		settings = {
			Lua = {
				globals = {
					"vim",
				},
				telemetry = {
					enable = false,
				},
				format = {
					enable = true,
				},
				workspace = {
					library = vim.api.nvim_get_runtime_file("", true),
				}
			},
		},
	},
})
