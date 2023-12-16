local which_key = require("which-key")

-- Javascript
vim.cmd.dxvim.enable_lsp("flow", {
	null_ls_setup = { "formatting.prettier", "diagnostics.eslint" },
})

-- Typescript
vim.cmd.dxvim.enable_lsp("tsserver", {
	null_ls_setup = { "formatting.prettier", "diagnostics.tsc" },
	lsp_setup = {
		settings = {
			typescript = {
				inlayHints = {
					includeInlayParameterNameHints = 'all',
					includeInlayParameterNameHintsWhenArgumentMatchesName = false,
					includeInlayFunctionParameterTypeHints = true,
					includeInlayVariableTypeHints = true,
					includeInlayVariableTypeHintsWhenTypeMatchesName = false,
					includeInlayPropertyDeclarationTypeHints = true,
					includeInlayFunctionLikeReturnTypeHints = true,
					includeInlayEnumMemberValueHints = true,
				}
			},
			javascript = {
				inlayHints = {
					includeInlayParameterNameHints = 'all',
					includeInlayParameterNameHintsWhenArgumentMatchesName = false,
					includeInlayFunctionParameterTypeHints = true,
					includeInlayVariableTypeHints = true,
					includeInlayVariableTypeHintsWhenTypeMatchesName = false,
					includeInlayPropertyDeclarationTypeHints = true,
					includeInlayFunctionLikeReturnTypeHints = true,
					includeInlayEnumMemberValueHints = true,
				}
			},
		},
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
