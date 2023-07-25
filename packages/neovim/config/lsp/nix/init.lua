local which_key = require("which-key")
local telescope_loaded, telescope = pcall(require, 'telescope')

vim.cmd.dxvim.enable_lsp("nixd", {
	null_ls_setup = { "formatting.nixfmt", "diagnostics.statix", "diagnostics.deadnix", "code_actions.statix" },
})

which_key.register({
	c = {
		u = { '<cmd>call Preserve("%!update-nix-fetchgit --location=" . line(".") . ":" . col("."))<CR>',
			'Update nix fetch git' },
		U = { '<cmd>!fd .nix --exec update-nix-fetchgit<cr>', 'Update all nix files in repo' },
	},
}, { mode = "n", prefix = "<leader>", silent = true })

if telescope_loaded then
	-- Import manix so that Telescope can load it properly.
	---@diagnostic disable-next-line: unused-local
	local manix = require("telescope-manix")

	telescope.load_extension("manix")

	which_key.register({
		["<C-p>"] = {
			n = { "<cmd>Telescope manix<cr>", "Nix Documentation" },
		},
	}, { mode = "n", silent = true })
end
