vim.cmd.dxvim.enable_lsp("cmake", {
	null_ls_setup = { "formatting.cmake_format", "diagnostics.cmake_lint" },
})
