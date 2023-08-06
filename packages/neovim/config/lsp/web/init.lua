-- HTML
vim.cmd.dxvim.enable_lsp("html", {
	null_ls_setup = { "formatting.prettier", "diagnostics.tidy" },
})

-- CSS
vim.cmd.dxvim.enable_lsp("cssls", {
	null_ls_setup = { "formatting.prettier", "diagnostics.stylelint" },
})
