local schemastore = require('schemastore')

-- Markdown
vim.cmd.dxvim.enable_lsp("marksman", {
	null_ls_setup = { "formatting.mdformat", "diagnostics.markdownlint" },
})

-- JSON
vim.cmd.dxvim.enable_lsp("jsonls", {
	null_ls_setup = { "formatting.prettier", "diagnostics.jsonlint" },
	lsp_setup = {
		settings = {
			json = {
				schemas = schemastore.json.schemas(),
				validate = { enable = true },
			},
		},
	}
})

-- YAML
vim.cmd.dxvim.enable_lsp("yamlls", {
	null_ls_setup = { "formatting.prettier", "diagnostics.yamllint" },
	lsp_setup = {
		settings = {
			yaml = {
				schemaStore = {
					-- You must disable built-in schemaStore support if you want to use
					-- this plugin and its advanced options like `ignore`.
					enable = false,
					-- Avoid TypeError: Cannot read properties of undefined (reading 'length')
					url = "",
				},
				schemas = schemastore.yaml.schemas(),
			},
		},
	}
})

-- TOML
vim.cmd.dxvim.enable_lsp("taplo", {
	null_ls_setup = { "formatting.taplo" },
})
