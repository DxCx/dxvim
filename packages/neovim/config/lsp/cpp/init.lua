vim.cmd.dxvim.enable_lsp("clangd", {
	null_ls_setup = { "formatting.clang_format", "diagnostics.clang_check", "diagnostics.clazy" },
	lsp_capabilities = {
		offsetEncoding = "utf-8",
		offset_encoding = "utf-8",
	},
	lsp_setup = {
		cmd = { 'clangd', '--background-index', '--header-insertion=iwyu', "--clang-tidy", "--cross-file-rename",
			"--completion-style=bundled" },
		init_options = {
			clangdFileStatus = true, -- Provides information about activity on clangd’s per-file worker thread
			usePlaceholders = true,
			completeUnimported = true,
			semanticHighlighting = true,
		},
	},
})
