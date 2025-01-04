local copilot = require('copilot')
local copilot_cmp = require("copilot_cmp")
local copilot_chat = require("CopilotChat")
local copilot_cmp_comparators = require("copilot_cmp.comparators")
local which_key = require("which-key")

-- Generate wrapper for user input
local chat_ask_user = function(opts)
	-- Select selection method based on using range or not.
	local selection = require("CopilotChat.select").buffer
	if opts.range then
		selection = require("CopilotChat.select").visual
	end

	-- Obtain input from the user and ask in chat
	vim.ui.input({ prompt = "Copilot Chat : " }, function(user_input)
		copilot_chat.ask(user_input, {
			selection = selection,
		})
	end)
end
vim.api.nvim_create_user_command('CopilotChatUserFreeText', chat_ask_user, { range = true })

-- To use in commit, toggle verbose commit using 'git config --global commit.verbose true'
local chat_config = {
	normal = {
		-- Git commit related prompts
		g = { "Commit", "Git commit" },
		d = { "FixDiagnostic", "Fix diagnostic" },

		-- special case of opening a prompt over the whole file
		["<cr>"] = { "UserFreeText", "Free text" },
	},
	visual = {
		-- Code related prompts
		e = { "Explain", "Explain code" },
		r = { "Review", "Review code" },
		f = { "Fix", "Fix code" },
		o = { "Optimize", "Optimize code" },
		d = { "Docs", "Document code" },
		t = { "Tests", "Generate tests" },

		-- special case of opening a prompt
		["<cr>"] = { "UserFreeText", "Free text" },
	},
}

-- Register visual mode bindings
local visual_bindings = {}
for k, v in pairs(chat_config.visual) do
	visual_bindings[k] = { ':CopilotChat' .. v[1] .. "<cr>", v[2] };
end

which_key.register({
	c = {
		c = vim.cmd.dxvim.table_merge({
			name = "Copilot Chat",
		}, visual_bindings),
	},
}, { mode = "x", noremap = true, silent = true, prefix = "<leader>" })

-- register normal mode bindings
local normal_bindings = {}
for k, v in pairs(chat_config.normal) do
	normal_bindings[k] = { ':CopilotChat' .. v[1] .. "<cr>", v[2] };
end

which_key.register({
	c = {
		c = vim.cmd.dxvim.table_merge({
			name = "Copilot Chat",
		}, normal_bindings),
	},
}, { mode = "n", noremap = true, silent = true, prefix = "<leader>" })

copilot_chat.setup({})

copilot.setup({
	suggestion = { enabled = false },
	panel = {
		enabled = true,
		auto_refresh = true,
		keymap = {
			jump_prev = "[[",
			jump_next = "]]",
			accept = "<CR>",
			refresh = "gr",
			open = "<M-CR>"
		},
		layout = {
			position = "bottom", -- | top | left | right
			ratio = 0.4
		},
	},
	filetypes = {
		gitcommit = true,
		markdown  = true,
		yaml      = true,
		plantuml  = true,
	}
})
copilot_cmp.setup()

vim.cmd.dxvim.update_lsp_cmp_setup({
	sorting = {
		comparators = {
			copilot_cmp_comparators.prioritize,
		},
	},
	sources = {
		{ name = "copilot", group_index = 2 },
	},
})

-- Register copilot bindings
which_key.register({
	c = {
		name = "Code",
		s = { "<cmd>:Copilot panel<cr>", "Copilot suggest" },
	},
}, { mode = "n", noremap = true, silent = true, prefix = "<leader>" })
