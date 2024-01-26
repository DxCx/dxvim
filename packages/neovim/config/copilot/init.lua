local copilot = require('copilot')
local copilot_cmp = require("copilot_cmp")
local copilot_chat = require("CopilotChat")
local copilot_cmp_comparators = require("copilot_cmp.comparators")
local which_key = require("which-key")

-- To use in commit, toggle verbose commit using 'git config --global commit.verbose true'
local chat_config = {
	normal = {
		-- Code related prompts
		g = { "GitCommit", "Please write a commit message for me, it should be descriptive and explain what was change and which problems it was trying to address", "Git commit" },
	},
	visual = {
		-- Code related prompts
		e = { "Explain", "Please explain how the following code works.", "Explain code" },
		r = { "Review", "Please review the following code and provide suggestions for improvements also, please let me know of any bugs you can think of", "Review code" },
		t = { "Tests", "Please explain how the selected code works, then generate unit tests for it.", "Generate tests" },
		R = { "Refactor", "Please refactor the following code to improve its clarity and readability.", "Refactor code" },

		-- Text related prompts
		s = { "Summarize", "Please summarize the following text.", "Summarize text" },
		S = { "Spelling", "Please correct any grammar and spelling errors in the following text.", "Correct spelling" },
		w = { "Wording", "Please improve the grammar and wording of the following text.", "Improve wording" },
		c = { "Concise", "Please rewrite the following text to make it more concise.", "Make text concise" },

		-- special case of opening a prompt
		["<cr>"] = { "UserFreeText", function()
			vim.ui.input({ prompt = "Copilot Chat : " }, function(question)
				vim.cmd.CopilotChat(question)
			end)
		end, "Free text" },
	},
}

-- build promp config
local chat_prompts = {}
for _, v in pairs(chat_config) do
	for _, vv in pairs(v) do
		if (type(vv[2]) == "string") then
			chat_prompts[vv[1]] = vv[2]
		else
			vim.api.nvim_create_user_command('CopilotChat' .. vv[1], vv[2], {})
		end
	end
end

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
}, { mode = "n", noremap = true, silent = true, prefix = "<leader>" })

function copilot_chat_execute(func_name)
	local command = "CopilotChat" .. func_name

	-- TODO: This doesnt work due to a race with command and restoring yank.
	-- if loosing yank becomes annoying in the future, revisit this solution
	--
	-- backup register before yank
	-- local yank_reg = '"'
	-- local old_reg = vim.fn.getreg(yank_reg)
	-- local old_reg_type = vim.fn.getregtype(yank_reg)

	-- execute the command
	vim.cmd(command)

	-- restore old register value
	-- vim.fn.setreg(yank_reg, old_reg, old_reg_type)
end

-- Register visual mode bindings
local visual_bindings = {}
for k, v in pairs(chat_config.visual) do
	visual_bindings[k] = { function()
		-- yank selected
		vim.api.nvim_feedkeys('y', 'x', false)
		copilot_chat_execute(v[1])
	end, v[3] }
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
	normal_bindings[k] = { function()
		-- yank all
		vim.api.nvim_feedkeys('ggVGy', 'x', false)
		copilot_chat_execute(v[1])
	end, v[3] }
end

which_key.register({
	c = {
		c = vim.cmd.dxvim.table_merge({
			name = "Copilot Chat",
		}, normal_bindings),
	},
}, { mode = "n", noremap = true, silent = true, prefix = "<leader>" })
