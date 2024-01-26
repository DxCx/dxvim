local copilot = require('copilot')
local copilot_cmp = require("copilot_cmp")
local copilot_chat = require("CopilotChat")
local copilot_cmp_comparators = require("copilot_cmp.comparators")
local which_key = require("which-key")

local chat_prompts = {
	-- Code related prompts
	Explain = "Please explain how the following code works.",
	Review = "Please review the following code and provide suggestions for improvement.",
	Tests = "Please explain how the selected code works, then generate unit tests for it.",
	Refactor = "Please refactor the following code to improve its clarity and readability.",
	-- Text related prompts
	Summarize = "Please summarize the following text.",
	Spelling = "Please correct any grammar and spelling errors in the following text.",
	Wording = "Please improve the grammar and wording of the following text.",
	Concise = "Please rewrite the following text to make it more concise.",
}

local chat_bindings = {
	e = { "<cmd>:CopilotChatExplain<cr>", "Explain code" },
	t = { "<cmd>:CopilotChatTests<cr>", "Generate tests" },
	r = { "<cmd>:CopilotChatReview<cr>", "Review code" },
	R = { "<cmd>:CopilotChatRefactor<cr>", "Refactor code" },
	s = { "<cmd>:CopilotChatSummarize<cr>", "Summarize text" },
	S = { "<cmd>:CopilotChatSpelling<cr>", "Correct spelling" },
	w = { "<cmd>:CopilotChatWording<cr>", "Improve wording" },
	c = { "<cmd>:CopilotChatConcise<cr>", "Make text concise" },
}

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

copilot_chat.setup({
	mode = "split",
	prompts = chat_prompts,
})

-- Register copilot bindings
which_key.register({
	c = {
		name = "Code",
		s = { "<cmd>:Copilot panel<cr>", "Copilot suggest" },
	},
})

-- Register copilot chat bindings
which_key.register({
	c = {
		c = vim.cmd.dxvim.table_merge({
			name = "Copilot Chat",
		}, chat_bindings),
	},
}, { mode = "n", noremap = true, silent = true, prefix = "<leader>" })

yanked_bindings = {}

for k, v in pairs(chat_bindings) do
	-- append yanking of selected
	yanked_bindings[k] = { "y" .. v[1], v[2] }
end

-- Register again to yank selected text before command
which_key.register({
	c = {
		c = vim.cmd.dxvim.table_merge({
			name = "Copilot Chat",
		}, yanked_bindings),
	},
}, { mode = "x", noremap = true, silent = true, prefix = "<leader>" })
