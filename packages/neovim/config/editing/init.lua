local indent = require("ibl")
local which_key = require("which-key")
local todo = require("todo-comments")
local surround = require("nvim-surround")
local comment = require("nvim_comment")
local snacks = require("snacks")
local mini_jump2d = require('mini.jump2d')

surround.setup()
comment.setup()

-- Plugin for leap/hop functionality - display a 2D grid of characters to jump to.
mini_jump2d.setup({
	view = { dim = true },
	allowed_windows = {
		current = true,
		not_current = false,
	},
	mappings = {
		start_jumping = "",
	},
})

local H = {}
local my_spotter = (function()
	local word_start = mini_jump2d.gen_pattern_spotter('[^%s%p]+', 'start')
	local word_end = mini_jump2d.gen_pattern_spotter('[^%s%p]+', 'end')

	return function(line_num, args)
		return vim.cmd.dxvim.table_merge(word_start(line_num, args), word_end(line_num, args))
	end
end)()

local jump_forward = function()
	mini_jump2d.start({
		spotter = my_spotter,
		allowed_lines = {
			blank = false, -- Blank line (not sent to spotter even if `true`)
			cursor_before = false, -- Lines before cursor line
			cursor_at = true, -- Cursor line
			cursor_after = true, -- Lines after cursor line
			fold = false, -- Start of fold (not sent to spotter even if `true`)
		}
	})
end

local jump_backward = function()
	mini_jump2d.start({
		spotter = my_spotter,
		allowed_lines = {
			blank = false, -- Blank line (not sent to spotter even if `true`)
			cursor_before = true, -- Lines before cursor line
			cursor_at = true, -- Cursor line
			cursor_after = false, -- Lines after cursor line
			fold = false, -- Start of fold (not sent to spotter even if `true`)
		}
	})
end

which_key.register({
	w = { jump_forward, "Jump 2D (Forward)" },
	b = { jump_backward, "Jump 2D (Backward)" },
}, { mode = "n" })

-- TODO: Comments enhancement and tracking
todo.setup()

-- indent blankline
vim.opt.list = true
-- Disabled, abit annoying as it makes copy paste from vim harder.
--vim.opt.listchars:append "space:⋅"
vim.opt.listchars:append "eol:↴"
vim.g.BufKillCreateMappings = 0

vim.g.indent_blankline_use_treesitter = true

vim.g.indent_blankline_buftype_exclude = {
	"terminal",
	"nofile",
}

vim.g.indent_blankline_filetype_exclude = {
	"help",
	"dashboard",
	"NvimTree",
	"Trouble",
}

indent.setup()

--- TODO: Should i move this to more accessible place?
icons = {
	diagnostics = {
		Error = ' ',
		Hint = '󰠠 ',
		Information = ' ',
		Question = ' ',
		Warning = ' ',
	},
	documents = {
		File = ' ',
		FileEmpty = ' ',
		Files = ' ',
		Folder = ' ',
		FolderEmpty = ' ',
		Import = ' ',
		OpenFolder = ' ',
		OpenFolderEmpty = ' ',
		SymLink = ' ',
		SymlinkFolder = ' ',
	},
	git = {
		Add = ' ',
		AddAlt = ' ',
		Branch = ' ',
		Commit = "󰜘 ",
		Diff = ' ',
		DiffAlt = ' ',
		Directory = '',
		Ignore = '◌ ',
		Mod = ' ',
		Octoface = ' ',
		Remove = ' ',
		RemoveAlt = ' ',
		Rename = ' ',
		Repo = ' ',
		Tag = ' ',
		Untrack = ' ',
	},
	kind = {
		Class         = ' ',
		Color         = ' ',
		Constant      = ' ',
		Constructor   = '󰈏 ',
		Copilot       = ' ',
		Enum          = ' ',
		EnumMember    = ' ',
		Event         = ' ',
		Field         = ' ',
		File          = ' ',
		Folder        = ' ',
		Function      = '󰊕 ',
		Null          = " ",
		Interface     = ' ',
		Keyword       = ' ',
		Method        = ' ',
		Module        = '',
		Operator      = ' ',
		Property      = ' ',
		Reference     = ' ',
		Snippet       = ' ',
		Struct        = ' ',
		Text          = ' ',
		TypeParameter = ' ',
		Unit          = ' ',
		Value         = ' ',
		Variable      = ' ',
	},
	type = {
		Array = ' ',
		Boolean = '⏻ ',
		Number = ' ',
		Object = ' ',
		String = ' ',
	},
	ui = {
		Arrow               = ' ',
		ArrowClosed         = ' ',
		ArrowLeft           = ' ',
		ArrowOpen           = ' ',
		ArrowRight          = ' ',
		Bluetooth           = ' ',
		Bookmark            = ' ',
		Bug                 = ' ',
		Calendar            = ' ',
		Camera              = ' ',
		Check               = ' ',
		ChevronRight        = '',
		Circle              = ' ',
		CircleSmall         = '● ',
		CircleSmallEmpty    = '○ ',
		Clipboard           = ' ',
		Close               = ' ',
		Code                = ' ',
		Collapsed           = " ",
		Collection          = ' ',
		Color               = ' ',
		Command             = ' ',
		Comment             = ' ',
		Control             = " ",
		Copilot             = ' ',
		CopilotError        = ' ',
		Corner              = '└ ',
		Dashboard           = ' ',
		Database            = ' ',
		Download            = ' ',
		Edge                = '│ ',
		Edit                = ' ',
		Electric            = ' ',
		Eye                 = ' ',
		Fire                = ' ',
		Firefox             = ' ',
		Flag                = ' ',
		Game                = ' ',
		Gear                = ' ',
		GitHub              = ' ',
		Heart               = ' ',
		History             = ' ',
		Home                = ' ',
		Incoming            = ' ',
		Jump                = ' ',
		Key                 = " ",
		Keyboard            = '  ',
		LastLine            = "└╴",
		Ligthbulb           = '󰌵 ',
		List                = '',
		Lock                = ' ',
		MiddleLine          = "├╴",
		Minus               = '‒ ',
		Music               = '󰝚 ',
		Neovim              = ' ',
		NewFile             = ' ',
		None                = ' ',
		Note                = ' ',
		Outgoing            = ' ',
		Package             = ' ',
		Paint               = ' ',
		Pause               = ' ',
		Pencil              = ' ',
		Person              = ' ',
		Pin                 = ' ',
		Play                = ' ',
		Plug                = ' ',
		Plus                = ' ',
		Power               = ' ',
		PowerlineArrowLeft  = '',
		PowerlineArrowRight = '',
		PowerlineLeftRound  = '',
		PowerlineRightRound = '',
		Project             = ' ',
		Question            = ' ',
		Reload              = ' ',
		Rocket              = ' ',
		Save                = '󰆓 ',
		Search              = ' ',
		Separator           = '▊ ',
		SeparatorDashed     = '┆',
		SeparatorLight      = '▍',
		SignIn              = ' ',
		SignOut             = ' ',
		Sleep               = '󰒲 ',
		Star                = ' ',
		Table               = ' ',
		Telescope           = ' ',
		Terminal            = ' ',
		Test                = ' ',
		Time                = ' ',
		Topline             = '‾',
		Trash               = ' ',
		Unknown             = " ",
		User                = ' ',
		VerticalLine        = "│ ",
		Vim                 = ' ',
		Wifi                = ' ',
		Windows             = ' ',
	},
}

-- TODO: Register relevant toggle, leader T.
-- TODO: replace telescope with picker, WHAT TO DO WITH MANIX integration? need to port to picker.
snacks.setup({
	animate = {
		enabled = false,
		duration = 20, -- ms per step
		easing = 'linear',
		fps = 60,
	},
	bigfile = {
		enabled = true,
		notify = true,
		size = 100 * 1024, -- 100 KB
	},
	bufdelete = { enabled = true },
	dashboard = {
		enabled = false,
		sections = {
			{ section = 'header' },
			{
				icon = icons.ui.Keyboard,
				title = 'Keymaps',
				section = 'keys',
				indent = 2,
				padding = 1,
			},
			{
				icon = icons.documents.File,
				title = 'Recent Files',
				section = 'recent_files',
				indent = 2,
				padding = 1,
			},
			{
				icon = icons.documents.OpenFolder,
				title = 'Projects',
				section = 'projects',
				indent = 2,
				padding = 1,
			},
			{ section = 'startup' },
		},
	},
	debug = { enabled = false },
	dim = {
		enabled = false,
		scope = {
			min_size = 5,
			max_size = 20,
			siblings = true,
		},
	},
	git = { enabled = false },
	gitbrowse = { enabled = true },
	indent = { --- Adds: | at indent level
		enabled = true,
		priority = 1,
		char = icons.ui.SeparatorLight,
		only_scope = false,
		only_current = false,
		hl = {
			'SnacksIndent1',
			'SnacksIndent2',
			'SnacksIndent3',
			'SnacksIndent4',
			'SnacksIndent5',
			'SnacksIndent6',
			'SnacksIndent7',
			'SnacksIndent8',
		},
	},
	input = {
		enabled = true,
		icon = icons.ui.Edit,
		icon_hl = 'SnacksInputIcon',
		icon_pos = 'left',
		prompt_pos = 'title',
		win = { style = 'input' },
		expand = true,
	},
	lazygit = {
		enabled = true,
		-- automatically configure lazygit to use the current colorscheme
		-- and integrate edit with the current neovim instance
		configure = true,
		-- extra configuration for lazygit that will be merged with the default
		-- snacks does NOT have a full yaml parser, so if you need `"test"` to appear with the quotes
		-- you need to double quote it: `"\"test\""`
		config = {
			os = { editPreset = "nvim-remote" },
			gui = {
				-- set to an empty string "" to disable icons
				nerdFontsVersion = "3",
			},
		},
		theme_path = vim.fs.normalize(vim.fn.stdpath("cache") .. "/lazygit-theme.yml"),
		-- Theme for lazygit
		theme = {
			[241]                      = { fg = "Special" },
			activeBorderColor          = { fg = "MatchParen", bold = true },
			cherryPickedCommitBgColor  = { fg = "Identifier" },
			cherryPickedCommitFgColor  = { fg = "Function" },
			defaultFgColor             = { fg = "Normal" },
			inactiveBorderColor        = { fg = "FloatBorder" },
			optionsTextColor           = { fg = "Function" },
			searchingActiveBorderColor = { fg = "MatchParen", bold = true },
			selectedLineBgColor        = { bg = "Visual" }, -- set to `default` to have no background colour
			unstagedChangesColor       = { fg = "DiagnosticError" },
		},
		win = {
			style = "lazygit",
		},
	},
	notifier = {
		enabled = true,
		timeout = 2000,
		width = { min = 40, max = 0.4 },
		height = { min = 1, max = 0.6 },
		margin = { top = 0, right = 1, bottom = 0 },
		padding = true,
		sort = { 'level', 'added' },
		level = vim.log.levels.TRACE,
		icons = {
			debug = icons.ui.Bug,
			error = icons.diagnostics.Error,
			info = icons.diagnostics.Information,
			trace = icons.ui.Bookmark,
			warn = icons.diagnostics.Warning,
		},
		style = 'compact',
		top_down = true,
		date_format = '%R',
		more_format = ' ↓ %d lines ',
		refresh = 50,
	},
	notify = { enabled = true },
	picker = {
		enabled = false,
		prompt = " ",
		sources = {},
		layout = {
			cycle = true,
			--- Use the default layout or vertical if the window is too narrow
			preset = function()
				return vim.o.columns >= 120 and "default" or "vertical"
			end,
		},
		---@class snacks.picker.matcher.Config
		matcher = {
			fuzzy = true, -- use fuzzy matching
			smartcase = true, -- use smartcase
			ignorecase = true, -- use ignorecase
			sort_empty = false, -- sort results when the search string is empty
			filename_bonus = true, -- give bonus for matching file names (last part of the path)
		},
		sort = {
			-- default sort is by score, text length and index
			fields = { "score:desc", "#text", "idx" },
		},
		ui_select = true, -- replace `vim.ui.select` with the snacks picker
		---@class snacks.picker.formatters.Config
		formatters = {
			file = {
				filename_first = false, -- display filename before the file path
			},
			selected = {
				show_always = false, -- only show the selected column when there are multiple selections
				unselected = true, -- use the unselected icon for unselected items
			},
		},
		---@class snacks.picker.previewers.Config
		previewers = {
			git = {
				native = false, -- use native (terminal) or Neovim for previewing git diffs and commits
			},
			file = {
				max_size = 1024 * 1024, -- 1MB
				max_line_length = 500, -- max line length
				ft = nil, ---@type string? filetype for highlighting. Use `nil` for auto detect
			},
			man_pager = nil, ---@type string? MANPAGER env to use for `man` preview
		},
		---@class snacks.picker.jump.Config
		jump = {
			jumplist = true, -- save the current position in the jumplist
			tagstack = false, -- save the current position in the tagstack
			reuse_win = false, -- reuse an existing window if the buffer is already open
		},
		win = {
			-- input window
			input = {
				keys = {
					["<Esc>"] = "close",
					["<C-c>"] = { "close", mode = "i" },
					-- to close the picker on ESC instead of going to normal mode,
					-- add the following keymap to your config
					-- ["<Esc>"] = { "close", mode = { "n", "i" } },
					["<CR>"] = { "confirm", mode = { "n", "i" } },
					["G"] = "list_bottom",
					["gg"] = "list_top",
					["j"] = "list_down",
					["k"] = "list_up",
					["/"] = "toggle_focus",
					["q"] = "close",
					["?"] = "toggle_help",
					["<a-d>"] = { "inspect", mode = { "n", "i" } },
					["<c-a>"] = { "select_all", mode = { "n", "i" } },
					["<a-m>"] = { "toggle_maximize", mode = { "i", "n" } },
					["<a-p>"] = { "toggle_preview", mode = { "i", "n" } },
					["<a-w>"] = { "cycle_win", mode = { "i", "n" } },
					["<C-w>"] = { "<c-s-w>", mode = { "i" }, expr = true, desc = "delete word" },
					["<C-Up>"] = { "history_back", mode = { "i", "n" } },
					["<C-Down>"] = { "history_forward", mode = { "i", "n" } },
					["<Tab>"] = { "select_and_next", mode = { "i", "n" } },
					["<S-Tab>"] = { "select_and_prev", mode = { "i", "n" } },
					["<Down>"] = { "list_down", mode = { "i", "n" } },
					["<Up>"] = { "list_up", mode = { "i", "n" } },
					["<c-j>"] = { "list_down", mode = { "i", "n" } },
					["<c-k>"] = { "list_up", mode = { "i", "n" } },
					["<c-n>"] = { "list_down", mode = { "i", "n" } },
					["<c-p>"] = { "list_up", mode = { "i", "n" } },
					["<c-b>"] = { "preview_scroll_up", mode = { "i", "n" } },
					["<c-d>"] = { "list_scroll_down", mode = { "i", "n" } },
					["<c-f>"] = { "preview_scroll_down", mode = { "i", "n" } },
					["<c-g>"] = { "toggle_live", mode = { "i", "n" } },
					["<c-u>"] = { "list_scroll_up", mode = { "i", "n" } },
					["<ScrollWheelDown>"] = { "list_scroll_wheel_down", mode = { "i", "n" } },
					["<ScrollWheelUp>"] = { "list_scroll_wheel_up", mode = { "i", "n" } },
					["<c-v>"] = { "edit_vsplit", mode = { "i", "n" } },
					["<c-s>"] = { "edit_split", mode = { "i", "n" } },
					["<c-q>"] = { "qflist", mode = { "i", "n" } },
					["<a-i>"] = { "toggle_ignored", mode = { "i", "n" } },
					["<a-h>"] = { "toggle_hidden", mode = { "i", "n" } },
				},
				b = {
					minipairs_disable = true,
				},
			},
			-- result list window
			list = {
				keys = {
					["<CR>"] = "confirm",
					["gg"] = "list_top",
					["G"] = "list_bottom",
					["i"] = "focus_input",
					["j"] = "list_down",
					["k"] = "list_up",
					["q"] = "close",
					["<Tab>"] = "select_and_next",
					["<S-Tab>"] = "select_and_prev",
					["<Down>"] = "list_down",
					["<Up>"] = "list_up",
					["<a-d>"] = "inspect",
					["<c-d>"] = "list_scroll_down",
					["<c-u>"] = "list_scroll_up",
					["zt"] = "list_scroll_top",
					["zb"] = "list_scroll_bottom",
					["zz"] = "list_scroll_center",
					["/"] = "toggle_focus",
					["<ScrollWheelDown>"] = "list_scroll_wheel_down",
					["<ScrollWheelUp>"] = "list_scroll_wheel_up",
					["<c-a>"] = "select_all",
					["<c-f>"] = "preview_scroll_down",
					["<c-b>"] = "preview_scroll_up",
					["<c-v>"] = "edit_vsplit",
					["<c-s>"] = "edit_split",
					["<c-j>"] = "list_down",
					["<c-k>"] = "list_up",
					["<c-n>"] = "list_down",
					["<c-p>"] = "list_up",
					["<a-w>"] = "cycle_win",
					["<Esc>"] = "close",
				},
			},
			-- preview window
			preview = {
				keys = {
					["<Esc>"] = "close",
					["q"] = "close",
					["i"] = "focus_input",
					["<ScrollWheelDown>"] = "list_scroll_wheel_down",
					["<ScrollWheelUp>"] = "list_scroll_wheel_up",
					["<a-w>"] = "cycle_win",
				},
			},
		},
		---@class snacks.picker.icons
		icons = {
			files = {
				enabled = true, -- show file icons
			},
			indent = {
				vertical = icons.ui.VerticalLine,
				middle   = icons.ui.MiddleLine,
				last     = icons.ui.LastLine,
			},
			ui = {
				live       = "󰐰 ",
				hidden     = "h",
				ignored    = "i",
				selected   = "● ",
				unselected = "○ ",
				-- selected = " ",
			},
			git = {
				commit = icons.git.Commit,
			},
			diagnostics = {
				Error = icons.diagnostics.Error,
				Warn  = icons.diagnostics.Warning,
				Hint  = icons.diagnostics.Hint,
				Info  = icons.diagnostics.Information,
			},
			kinds = {
				Array         = icons.type.Array,
				Boolean       = icons.type.Boolean,
				Class         = icons.kind.Class,
				Color         = icons.kind.Color,
				Control       = icons.ui.Control,
				Collapsed     = icons.ui.Collapsed,
				Constant      = icons.kind.Constant,
				Constructor   = icons.kind.Constructor,
				Copilot       = icons.kind.Copilot,
				Enum          = icons.kind.Enum,
				EnumMember    = icons.kind.EnumMember,
				Event         = icons.kind.Event,
				Field         = icons.kind.Field,
				File          = icons.kind.File,
				Folder        = icons.kind.Folder,
				Function      = icons.kind.Function,
				Interface     = icons.kind.Interface,
				Key           = icons.ui.Key,
				Keyword       = icons.ui.Keyword,
				Method        = icons.kind.Method,
				Module        = icons.kind.module,
				Namespace     = icons.kind.Namespace,
				Null          = icons.kind.Null,
				Number        = icons.type.Number,
				Object        = icons.type.Object,
				Operator      = icons.kind.Operator,
				Package       = icons.ui.Package,
				Property      = icons.kind.Property,
				Reference     = icons.kind.Reference,
				Snippet       = icons.kind.Snippet,
				String        = icons.type.String,
				Struct        = icons.kind.Struct,
				Text          = icons.kind.Text,
				TypeParameter = icons.kind.TypeParameter,
				Unit          = icons.kind.Unit,
				Unknown       = icons.ui.Unknown,
				Value         = icons.kind.Value,
				Variable      = icons.kind.Variable,
			},
		},
		---@class snacks.picker.debug
		debug = {
			scores = false, -- show scores in the list
		},
	},
	profiler = { enabled = true },
	quickfile = { enabled = true },
	--- NOTE: This is integration for nvim-tree to event lsp about file renames.
	rename = { enabled = false },
	scope = {
		enabled = true,
		keys = {
			textobject = {
				ii = {
					min_size = 2, -- minimum size of the scope
					edge = false, -- inner scope
					cursor = false,
					treesitter = { blocks = { enabled = false } },
					desc = 'inner scope',
				},
				ai = {
					cursor = false,
					min_size = 2, -- minimum size of the scope
					treesitter = { blocks = { enabled = false } },
					desc = 'full scope',
				},
			},
			jump = {
				['[i'] = {
					min_size = 1, -- allow single line scopes
					bottom = false,
					cursor = false,
					edge = true,
					treesitter = { blocks = { enabled = false } },
					desc = 'jump to top edge of scope',
				},
				[']i'] = {
					min_size = 1, -- allow single line scopes
					bottom = true,
					cursor = false,
					edge = true,
					treesitter = { blocks = { enabled = false } },
					desc = 'jump to bottom edge of scope',
				},
			},
		},
	},
	--- NOTE: Scratchpad for godbolt like functionality.
	scratch = {
		enabled = false,
		name = 'SCRATCH',
		ft = function()
			if vim.bo.buftype == '' and vim.bo.filetype ~= '' then
				return vim.bo.filetype
			end
			return 'markdown'
		end,
		icon = nil,
		root = vim.fn.stdpath('data') .. '/scratch',
		autowrite = true,
		filekey = {
			cwd = true,
			branch = true,
			count = true,
		},
		win = {
			width = 120,
			height = 40,
			bo = { buftype = '', buflisted = false, bufhidden = 'hide', swapfile = false },
			minimal = false,
			noautocmd = false,
			zindex = 20,
			wo = { winhighlight = 'NormalFloat:Normal' },
			border = 'rounded',
			title_pos = 'center',
			footer_pos = 'center',

			keys = {
				['execute'] = {
					'<cr>',
					function(_)
						vim.cmd('%SnipRun')
					end,
					desc = 'Execute buffer',
					mode = { 'n', 'x' },
				},
			},
		},
		win_by_ft = {
			lua = {
				keys = {
					['source'] = {
						'<cr>',
						function(self)
							local name = 'scratch.' .. vim.fn.fnamemodify(vim.api.nvim_buf_get_name(self.buf), ':e')
							Snacks.debug.run({ buf = self.buf, name = name })
						end,
						desc = 'Source buffer',
						mode = { 'n', 'x' },
					},
					['execute'] = {
						'e',
						function(_)
							vim.cmd('%SnipRun')
						end,
						desc = 'Execute buffer',
						mode = { 'n', 'x' },
					},
				},
			},
		},
	},
	scroll = {
		enabled = false,
		animate = {
			duration = { step = 45, total = 250 },
			easing = "linear",
		},
		-- faster animation when repeating scroll after delay
		animate_repeat = {
			delay = 100, -- delay in ms before using the repeat animation
			duration = { step = 5, total = 50 },
			easing = "linear",
		},
		-- what buffers to animate
		filter = function(buf)
			return vim.g.snacks_scroll ~= false and vim.b[buf].snacks_scroll ~= false and
				vim.bo[buf].buftype ~= "terminal"
		end,
	},
	statuscolumn = {
		enabled = false,
		left = { 'mark', 'sign' },
		right = { 'fold', 'git' },
		folds = {
			open = false,
			git_hl = false,
		},
		git = {
			patterns = { 'GitSign', 'MiniDiffSign' },
		},
		refresh = 50,
	},
	terminal = { enabled = false },
	toggle = { enabled = true },
	win = { enabled = true },
	words = { enabled = true },
	--- NOTE: Abit annoying, trying dim only
	zen = {
		enabled = false,
		toggles = {
			dim = true,
			git_signs = false,
			mini_diff_signs = false,
			-- diagnostics = false,
			-- inlay_hints = false,
		},
		show = {
			statusline = false,
			tabline = false,
		},
		win = { style = 'zen' },
		zoom = {
			toggles = {},
			show = { statusline = true, tabline = true },
			win = {
				backdrop = false,
				width = 0,
			},
		},
	},
})

which_key.register({
	t = {
		name = "Toggle",
		g = { function() Snacks.lazygit() end, "Toggle LazyGIT overlay" },
	}
}, { mode = "n", prefix = "<leader>" })
