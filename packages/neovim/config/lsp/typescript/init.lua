local which_key = require("which-key")

-- Javascript
vim.cmd.dxvim.enable_lsp("flow", {
	null_ls_setup = { "formatting.prettier", "diagnostics.eslint" },
})

-- Typescript
vim.cmd.dxvim.enable_lsp("tsserver", {
	null_ls_setup = { "formatting.prettier", "diagnostics.tsc" },
	lsp_setup = {
		on_attach = function(client, buffer)
			which_key.register({
				c = {
					i = {
						name = "Imports",
						o = { "<cmd>OrganizeImports<cr>", "Organize" },
					},
				}
			}, { buffer = buffer, mode = "n", prefix = "<leader>", noremap = true, silent = true })
		end,
	},
})
