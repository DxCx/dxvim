local copilot = require('copilot')
local copilot_cmp = require("copilot_cmp")
local copilot_cmp_comparators = require("copilot_cmp.comparators")

local codecompanion = require("codecompanion")

local which_key = require("which-key")

-- TODO: Selecting agent for copilot cmp is not supported yet,
-- but have feature request (https://github.com/zbirenbaum/copilot.lua/issues/365)
-- Check again later.
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
		{ name = "copilot", group_index = 0 },
	},
})


-- NOTE: Plugin Owner personal dotfiles: https://github.com/olimorris/dotfiles/blob/ac72e83757564a41fd36809dd72ac1b62031c5db/.config/nvim/lua/plugins/coding.lua#L265
-- TODO: Return copilot cmp, it did not replace it... :\

codecompanion.setup({
	strategies = {
		chat = {
			adapter = "copilot",
		},
		inline = { adapter = "copilot", },
	},
	adapters = {
		copilot = function()
			return require("codecompanion.adapters").extend("copilot", {
				schema = {
					model = {
						default = "claude-3.5-sonnet",
					},
				},
			})
		end,
	},
	display = {
		action_palette = {
			provider = "telescope", -- default|telescope|mini_pick
		},
		diff = {
			provider = "default", -- default|mini_diff
		},
	},
})

function VisualSelectionToCodeCompanionChat(mode)
    local prefix = ""

    -- Prepare selection prefix if in visual mode
    if mode == "v" or mode == "V" then
        local filetype = vim.bo.filetype
        local fence_start = "```" .. (filetype ~= "" and filetype or "")

        -- Get start and end positions
        local start_pos = vim.fn.getpos("'<")
        local end_pos = vim.fn.getpos("'>")
        local start_row, start_col = start_pos[2], start_pos[3]
        local end_row, end_col = end_pos[2], end_pos[3]

        if start_row ~= 0 and end_row ~= 0 then
            local lines = vim.api.nvim_buf_get_lines(0, start_row - 1, end_row, false)
            
            -- Handle single line selection
            if #lines == 1 then
                lines[1] = vim.fn.strpart(lines[1], start_col - 1, end_col - start_col + 1)
            else
                -- Handle multi-line selection
                lines[1] = vim.fn.strpart(lines[1], start_col - 1)
                lines[#lines] = vim.fn.strpart(lines[#lines], 0, end_col)
            end

            prefix = "\n\n" .. fence_start .. "\n" .. table.concat(lines, "\n") .. "\n```\n\n"
        end
    end

    -- Single input handling for both modes
    vim.ui.input({ prompt = 'Ask Companion Chat: ' }, function(input)
        if input then
            local full_prompt = prefix .. input
            vim.cmd.CodeCompanionChat(full_prompt)
        end
    end)
end

-- Register copilot bindings
which_key.register({
	c = {
		c = {
			name = "CodeCompanion Chat",
			["<cr>"] = { '<cmd>:lua VisualSelectionToCodeCompanionChat("v")<CR>', "CodeCompanion Ask" },
			i = { "<cmd>:CodeCompanion<CR>", "CodeCompanion Ask inline" },
			a = { "<cmd>:CodeCompanionAction<CR>", "CodeCompanion Action" },
			f = { "<cmd>:CodeCompanion \"/Fix code\"<CR>", "CodeCompanion Fix code" },
			e = { "<cmd>:CodeCompanion \"/Explain\"<CR>", "CodeCompanion Explain code" },
		}
	},
}, { mode = "v", noremap = true, silent = true, prefix = "<leader>" })

which_key.register({
	c = {
		c = {
			name = "CodeCompanion Chat",
			["<cr>"] = { '<cmd>:lua VisualSelectionToCodeCompanionChat("n")<CR>', "CodeCompanion Ask" },
			i = { "<cmd>:CodeCompanion<CR>", "CodeCompanion Ask inline" },
			a = { "<cmd>:CodeCompanionAction<CR>", "CodeCompanion Action" },
			-- To use in commit, toggle verbose commit using 'git config --global commit.verbose true'
			g = { "<cmd>:CodeCompanion \"/Generate a Commit Message\"<CR>", "CodeCompanion Git Commit" },
		}
	},
}, { mode = "n", noremap = true, silent = true, prefix = "<leader>" })
