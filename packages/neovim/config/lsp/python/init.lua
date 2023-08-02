vim.cmd.dxvim.enable_lsp("pyright", {
	null_ls_setup = { "formatting.black", "diagnostics.flake8", "diagnostics.mypy", "diagnostics.ruff" },
})
