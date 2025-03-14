local which_key = require("which-key")

local codecompanion = require("codecompanion")

codecompanion.setup({
	strategies = {
		chat = { adapter = "copilot" },
		inline = { adapter = "copilot" },
	},
	display = {
		action_palette = {
			provider = "telescope", -- default|telescope|mini_pick
		},
	},
})

-- Function to get user input and pass it to CodeCompanionChat command
function VisualSelectionToCodeCompanionChat()
	-- Get the visual selection with column positions
	local start_pos = vim.fn.getpos("'<")
	local end_pos = vim.fn.getpos("'>")
	local lines = vim.fn.getline(start_pos[2], end_pos[2])

	-- Handle partial line selections
	if #lines == 1 then
		lines[1] = lines[1]:sub(start_pos[3], end_pos[3])
	else
		lines[1] = lines[1]:sub(start_pos[3])
		lines[#lines] = lines[#lines]:sub(1, end_pos[3])
	end
	local selection = table.concat(lines, "\n")

	-- Get the current buffer's filetype
	local filetype = vim.bo.filetype
	local fence_start = "```" .. (filetype ~= "" and filetype or "")

	-- Open input prompt to receive question from user
	vim.ui.input({ prompt = 'Ask Companion Chat: ' }, function(input)
		if input then
			-- Combine the selection and the question with filetype
			local full_prompt = input .. "\n\n" .. fence_start .. "\n" .. selection .. "\n```"
			-- Use proper command construction
			vim.cmd.CodeCompanionChat(full_prompt)
		end
	end)
end

-- Register copilot bindings
which_key.register({
	c = {
		c = {
			name = "CodeCompanion Chat",
			["<cr>"] = { ':<C-U>lua VisualSelectionToCodeCompanionChat()<CR>', "CodeCompanion Ask" },
			i = { "<cmd>:CodeCompanion<CR>", "CodeCompanion Ask inline" },
			a = { "<cmd>:CodeCompanionAction<CR>", "CodeCompanion Action" },
			f = { "<cmd>:CodeCompanion \"/Fix code\"<CR>", "CodeCompanion Fix code" },
		}
	},
}, { mode = "v", noremap = true, silent = true, prefix = "<leader>" })
