-- NullLs can be updated using direnv, for example, replacing python provider:
-- vim.cmd.dxvim.update_lsp("pyright", {
--     null_ls_setup = { "formatting.autopep8", "diagnostics.flake8", "diagnostics.mypy", "diagnostics.ruff" },
-- })
--
-- https://github.com/neovim/nvim-lspconfig
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
local lsp = require("lspconfig")
local null_ls = require("null-ls")
local illuminate = require("illuminate")
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local treesitter_configs = require("nvim-treesitter.configs")
local cmp = require("cmp")
local cmp_config = require("cmp.config")
local cmp_types = require('cmp.types')
local luasnip = require("luasnip")
local lspkind = require("lspkind")
local trouble = require("trouble")
local refactoring = require("refactoring")
local inlayhints = require("lsp-inlayhints")
local lspecho = require("lspecho")

local which_key = require("which-key")

local g_on_attach_hooks = {}
local g_lsp_setups = {}
local g_registered_null_ls = {}

-- Configure diagnostic icons.
local g_diag_signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }

local g_cmp_lspkind = {
	mode = "symbol_text",
	preset = "default",
	symbol_map = {
		Copilot = "",
	},
}

local g_lsp_cmp_setup = {
	sources = {
		{ name = "nvim_lsp", group_index = 2, keyword_length = 1 },
		{ name = "luasnip",  group_index = 2, keyword_length = 2 },
	},
}

local cmp_border = function(hl_name)
	return {
		{ "╭", hl_name },
		{ "─", hl_name },
		{ "╮", hl_name },
		{ "│", hl_name },
		{ "╯", hl_name },
		{ "─", hl_name },
		{ "╰", hl_name },
		{ "│", hl_name },
	}
end

local has_words_before = function()
	if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
end

local cmp_next = cmp.mapping(vim.schedule_wrap(function(fallback)
	if cmp.visible() and has_words_before() then
		cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
	elseif luasnip.expand_or_jumpable() then
		luasnip.expand_or_jump()
	else
		fallback()
	end
end), { "i", "s" })

local cmp_prev = cmp.mapping(vim.schedule_wrap(function(fallback)
	if cmp.visible() and has_words_before() then
		cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
	elseif luasnip.jumpable(-1) then
		luasnip.jump(-1)
	else
		fallback()
	end
end), { "i", "s" })

local g_client_capabilities = {
	["textDocument/publishDiagnostics"] = function(_, _)
		return {
			keys = {
				["]"] = {
					d = { "<cmd>lua vim.diagnostic.goto_next()<cr>", "Next Diagnostic" },
				},
				["["] = {
					d = { "<cmd>lua vim.diagnostic.goto_prev()<cr>", "Previous Diagnostic" },
				},
			},
		}
	end,
	["textDocument/codeAction"] = function(_, _)
		return {
			keys = {
				["<leader>"] = {
					c = {
						a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Action" },
					}
				},
			},
		}
	end,
	["textDocument/declaration"] = function(_, _)
		return {
			keys = {
				g = {
					D = { "<cmd>lua vim.lsp.buf.declaration()<cr>", "Go to declaration" },
				},
			},
		}
	end,
	["textDocument/formatting"] = function(_, bufnr)
		-- Auto format on save.
		vim.api.nvim_create_autocmd(
			{ "BufWritePre" },
			{
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format {
						timeout = 500,
					}
				end,
			}
		)

		return {
			keys = {
				["<leader>"] = {
					c = {
						["="] = { "<cmd>lua vim.lsp.buf.format({ async = true })<cr>", "Format" },
					}
				},
			},
		}
	end,
	["textDocument/hover"] = function(_, _)
		return {
			keys = {
				g = {
					h = { "<cmd>lua vim.lsp.buf.hover()<cr>", "Hover" },
				},
			},
		}
	end,
	["textDocument/implementation"] = function(_, _)
		return {
			keys = {
				g = {
					i = { "<cmd>lua vim.lsp.buf.implementation()<cr>", "Go to implementation" },
				},
			},
		}
	end,
	["textDocument/references"] = function(_, _)
		return {
			keys = {
				g = {
					r = { "<cmd>lua vim.lsp.buf.references()<cr>", "Go to references" },
				},
			},
		}
	end,
	["textDocument/rename"] = function(_, _)
		return {
			keys = {
				["<leader>"] = {
					c = {
						r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
					}
				},
			},
		}
	end,
	["textDocument/signatureHelp"] = function(_, _)
		return {
			keys = {
				g = {
					["<C-k>"] = { "<cmd>lua vim.lsp.buf.signature_help()<cr>", "Signature help" }
				},
			},
			cmp_setup = {
				sources = {
					{ name = "nvim_lsp_signature_help", group_index = 2 },
				},
			}
		}
	end,
	["textDocument/typeDefinition"] = function(_, _)
		return {
			keys = {
				g = {
					d = { "<cmd>lua vim.lsp.buf.definition()<cr>", "Go to definition" },
					t = { "<cmd>lua vim.lsp.buf.type_definition()<cr>", "Go to type definition" },
				},
			},
		}
	end,
	["workspace/symbol"] = function(_, _)
		return {
			keys = {
				g = {
					w = { "<cmd>lua vim.lsp.buf.workspace_symbol()<cr>", "Search workspace symbols" },
				},
			},
		}
	end,
	["textDocument/documentSymbol"] = function(_, _)
		return {
			cmp_setup = {
				sources = {
					{ name = "nvim_lsp_document_symbol", group_index = 2 },
				},
			},
		}
	end,
	["textDocument/documentHighlight"] = function(_, _)
		-- TODO: Explore later
	end,
	["textDocument/inlayHint"] = function(_, _)
		return {
			keys = {
				["<leader>"] = {
					t = {
						h = { "<cmd>lua require('lsp-inlayhints').toggle()<cr>", "Toggle inlay hints" }
					}
				}
			}
		}
	end,
	["textDocument/codeLens"] = function(client, _)
		-- TODO: Explore later
		client.server_capabilities.codeLensProvider = nil
	end,
	["textDocument/semanticTokens/full"] = function(client, _)
		-- TODO: Explore later
		client.server_capabilities.semanticTokensProvider = nil
	end,
}

local function complete_or_action(action)
	return cmp.mapping({
		i = function()
			if cmp.visible() then
				action()
			else
				cmp.complete()
			end
		end
	})
end

local g_cmp_setup = {
	completion = {
		completeopt = "menu,menuone",
		autocomplete = {
			cmp_types.cmp.TriggerEvent.TextChanged,
		},
		keyword_pattern = [[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%(-\w*\)*\)]],
		keyword_length = 1,
	},
	window = {
		completion = {
			side_padding = 1,
			winhighlight = "Normal:CmpPmenu,Search:PmenuSel",
			scrollbar = true,
			border = cmp_border("CmpBorder"),
		},
		documentation = {
			border = cmp_border("CmpDocBorder"),
			winhighlight = "Normal:CmpDoc",
		},
	},
	formatting = {
		-- default fields order i.e completion word + item.kind + item.kind icons
		fields = { "abbr", "kind", "menu" },

		format = lspkind.cmp_format(g_cmp_lspkind),
	},
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	sorting = {
		priority_weight = 2,
		-- https://github.com/hrsh7th/nvim-cmp/blob/main/lua/cmp/config/default.lua#L62-L76
		comparators = {
			-- Below is the default comparitor list and order for nvim-cmp
			cmp.config.compare.offset,
			-- cmp.config.compare.scopes, --this is commented in nvim-cmp too
			cmp.config.compare.exact,
			cmp.config.compare.score,
			cmp.config.compare.recently_used,
			cmp.config.compare.locality,
			cmp.config.compare.kind,
			-- cmp.config.sort_text -- this is commented in nvim-cmp too
			cmp.config.compare.sort_text,
			cmp.config.compare.length,
			cmp.config.compare.order,
		},
	},
	sources = {
		{ name = "path",   group_index = 3, keyword_length = 3 },
		{ name = "buffer", group_index = 3, keyword_length = 2 },
	},
	mapping = {
		["<c-j>"] = cmp.mapping.scroll_docs(4),
		["<c-k>"] = cmp.mapping.scroll_docs(-4),
		["<esc>"] = cmp.mapping.abort(),
		["<c-y>"] = complete_or_action(function() cmp.confirm({ select = true }) end),
		["<c-n>"] = complete_or_action(cmp.select_next_item),
		["<c-p>"] = complete_or_action(cmp.select_prev_item),

		-- let copilot take over tab, using cmp as normal vim binding c+p/n
		["<tab>"] = cmp_next,
		["<s-tab>"] = cmp_prev,
	}
}

local function is_null_ls_formatting_enabed(bufnr)
	local file_type = vim.api.nvim_buf_get_option(bufnr, "filetype")
	local generators = require("null-ls.generators").get_available(
		file_type,
		require("null-ls.methods").internal.FORMATTING
	)
	return #generators > 0
end

local generate_lsp_cmp_setup = function(cmp_options)
	local cmp_setup = vim.deepcopy(g_cmp_setup)

	cmp_setup = vim.cmd.dxvim.table_merge(cmp_setup, g_lsp_cmp_setup)
	assert(cmp_setup ~= nil)

	if (cmp_options ~= nil) then
		cmp_setup = vim.cmd.dxvim.table_merge(cmp_setup, cmp_options)
	end

	return cmp_setup
end

local generate_default_client_settings = function(cmp_options)
	return {
		keys = {
			g = {
				name = "Go",
				n = { "<cmd>lua require('illuminate').next_reference{wrap=true}<cr>", "Go to next occurrence" },
				p = { "<cmd>lua require('illuminate').next_reference{reverse=true,wrap=true}<cr>",
					"Go to previous occurrence" },
			},
			["<leader>"] = {
				w = {
					name = "Workspace",
					a = { "<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>", "Add workspace" },
					l = { "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>", "List workspaces" },
					r = { "<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>", "Remove workspace" },
				},
				c = {
					name = "Code",
				}
			}
		},
		cmp_setup = generate_lsp_cmp_setup(cmp_options),
	}
end

local process_client_capabilities = function(client, bufnr, supported, cmp_options)
	local ret = generate_default_client_settings(cmp_options)

	for _, handler_type in ipairs(supported) do
		local merge_keys = g_client_capabilities[handler_type](client, bufnr)

		ret = vim.cmd.dxvim.table_merge(ret, merge_keys or {})
		assert(ret ~= nil)
	end

	return ret
end

local handle_client_capabilities = function(client, bufnr, cmp_options)
	local supported = {}

	if is_null_ls_formatting_enabed(bufnr) then
		-- We mostly use null-ls, disable formatting using lsp itself.
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false

		table.insert(supported, "textDocument/formatting")
	end

	for handler_type, _ in pairs(g_client_capabilities) do
		if client.supports_method(handler_type) then
			table.insert(supported, handler_type)
		end
	end

	-- Easier to debug with print
	-- print(vim.inspect(supported))

	return process_client_capabilities(client, bufnr, supported, cmp_options)
end

local set_lsp_cmp_on_buffer = function(bufnr, cmp_options)
	cmp_config.set_buffer(cmp_options, bufnr)
end

local dxvim_get_global_lsp_opts = function(name)
	local opts = g_lsp_setups[name]
	if (opts == nil) then
		opts = {}
	end

	return opts
end

local register_lsp_refactoring_key_bindings = function(bufnr)
	-- TODO: should export mode as part of "keys" and obtain those from default key bindings.
	-- Refactoring related keybindings, as they have more than normal mode.
	which_key.register({
		c = {
			f = { "<cmd>lua require('refactoring').refactor('Extract Function')<cr>", "Extract Function" },
			F = { "<cmd>lua require('refactoring').refactor('Extract Function To File')<cr>", "Extract Function To File" },
			v = { "<cmd>lua require('refactoring').refactor('Extract Variable')<cr>", "Extract Variable" },
			i = { "<cmd>lua require('refactoring').refactor('Inline Variable')<cr>", "Inline Variable" },
		}
	}, { buffer = bufnr, prefix = "<leader>", mode = "x", noremap = true, silent = true })

	which_key.register({
		c = {
			i = { "<cmd>lua require('refactoring').refactor('Inline Variable')<cr>", "Inline Variable" },
			b = { "<cmd>lua require('refactoring').refactor('Extract Block')<cr>", "Extract Block" },
			B = { "<cmd>lua require('refactoring').refactor('Extract Block To File')<cr>", "Extract Block To File" },
		}
	}, { buffer = bufnr, prefix = "<leader>", mode = "n", noremap = true, silent = true })
end

local register_lsp_key_bindings = function(bufnr, keys)
	register_lsp_refactoring_key_bindings(bufnr)

	-- Register lsp key bindings
	which_key.register(keys, { buffer = bufnr, mode = "n", noremap = true, silent = true })
end

-- after the language server attaches to the current buffer.
local global_on_attach = function(name, client, bufnr)
	local updated_opts = dxvim_get_global_lsp_opts(name)

	if (updated_opts.on_attach ~= nil) then
		updated_opts.on_attach(client, bufnr)
	end

	-- Execute registered hooks
	for _, f in ipairs(g_on_attach_hooks) do
		f(client, bufnr)
	end

	local per_buffer_opts = handle_client_capabilities(client, bufnr, updated_opts.lsp_cmp_setup)

	-- Easier to debug with print
	-- print(vim.inspect(per_buffer_opts))

	set_lsp_cmp_on_buffer(bufnr, per_buffer_opts.cmp_setup)

	illuminate.on_attach(client)

	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

	inlayhints.on_attach(client, bufnr)

	register_lsp_key_bindings(bufnr, per_buffer_opts.keys)
end

local global_capabilities = cmp_nvim_lsp.default_capabilities()
global_capabilities.textDocument.completion.completionItem = {
	documentationFormat = { "markdown", "plaintext" },
	snippetSupport = true,
	preselectSupport = true,
	insertReplaceSupport = true,
	labelDetailsSupport = true,
	deprecatedSupport = true,
	commitCharactersSupport = true,
	tagSupport = { valueSet = { 1 } },
	resolveSupport = {
		properties = {
			"documentation",
			"detail",
			"additionalTextEdits",
		},
	},
}

local load_null_ls_source = function(source)
	local builtin = null_ls.builtins
	for _, part in ipairs(vim.split(source, ".", { plain = true })) do
		builtin = builtin[part]
		assert(builtin ~= nil, "failed to load source '" .. source .. "' at part '" .. part .. "'")
	end

	return vim.deepcopy(builtin)
end

local generate_lsp_setup = function(name)
	local opts = dxvim_get_global_lsp_opts(name)

	local lsp_setup = {}
	if (opts.lsp_setup ~= nil) then
		lsp_setup = vim.deepcopy(opts.lsp_setup)
	end

	lsp_setup.on_attach = function(client, bufnr)
		global_on_attach(name, client, bufnr)
	end

	local local_capabilities = vim.deepcopy(global_capabilities)
	if (opts.lsp_capabilities ~= nil) then
		local_capabilities = vim.cmd.dxvim.table_merge(local_capabilities, opts.lsp_capabilities)
	end

	lsp_setup.capabilities = local_capabilities
	if (opts.filetypes ~= nil) then
		lsp_setup.filetypes = vim.deepcopy(opts.filetypes)
	end

	return lsp_setup
end

local handle_lsp_setup = function(name)
	local lsp_setup = generate_lsp_setup(name)

	lsp[name].setup(lsp_setup)
end

local dxvim_null_ls_registered = function(filetype, source)
	if (g_registered_null_ls[filetype] == nil) then
		g_registered_null_ls[filetype] = {}
	end

	for _, reg_source in ipairs(g_registered_null_ls[filetype]) do
		if (reg_source == source) then
			return true
		end
	end

	return false
end

local dxvim_insert_null_ls = function(source, filetypes, actual_sources)
	assert(filetypes ~= nil, "filetypes must be provided")

	local filtered_types = {}

	for _, filetype in ipairs(filetypes) do
		if (not dxvim_null_ls_registered(filetype, source)) then
			table.insert(filtered_types, filetype)
			table.insert(g_registered_null_ls[filetype], source)
		end
	end

	if #filtered_types == 0 then
		return actual_sources
	end

	local source_obj = nil
	if (type(source) == "string") then
		source_obj = load_null_ls_source(source)
	else
		source_obj = vim.deepcopy(source)
	end

	source_obj.filetypes = filtered_types

	table.insert(actual_sources, source_obj)
	return actual_sources
end

local handle_null_ls_setup = function(name)
	local opts = dxvim_get_global_lsp_opts(name)

	if (opts.null_ls_setup == nil) then
		return
	end

	local actual_sources = {}
	for _, source in ipairs(opts.null_ls_setup) do
		actual_sources = dxvim_insert_null_ls(source, opts.filetypes, actual_sources)
	end

	null_ls.register(actual_sources)
end

local dxvim_register_lsp = function(name, opts)
	assert(lsp[name] ~= nil, "lsp '" .. name .. "' does not exist")

	assert(g_lsp_setups[name] == nil)
	if opts == nil then
		opts = {}
	end

	if (opts.filetypes == nil) then
		opts.filetypes = lsp[name].document_config.default_config.filetypes
	end
	g_lsp_setups[name] = opts
end

local dxvim_on_lsp_start_service = function(name)
	handle_null_ls_setup(name)
	handle_lsp_setup(name)
end

local dxvim_enable_lsp = function(name, opts)
	dxvim_register_lsp(name, opts)

	dxvim_on_lsp_start_service(name)
end

local dxvim_reset_lsp = function()
	null_ls.disable {}
	null_ls.reset_sources()
	g_registered_null_ls = {}
end

local dxvim_update_lsp_options = function(name, opts)
	local orig = g_lsp_setups[name]
	assert(orig ~= nil)

	g_lsp_setups[name] = vim.cmd.dxvim.table_merge(orig, opts)
end

local dxvim_refersh_null_ls = function()
	for name, _ in pairs(g_lsp_setups) do
		handle_null_ls_setup(name)
	end
end

local dxvim_lsp_on_attach_hook = function(func)
	table.insert(g_on_attach_hooks, function(client, buffer)
		func(client, buffer)
	end)
end

local dxvim_update_lsp = function(name, opts)
	dxvim_reset_lsp()
	dxvim_update_lsp_options(name, opts)
	dxvim_refersh_null_ls()
end

local dxvim_update_lsp_cmp_setup = function(opts)
	assert(opts ~= nil, "opts must not be nil")

	g_lsp_cmp_setup = vim.cmd.dxvim.table_merge(g_lsp_cmp_setup, opts)
end

local hook_lsp_diagnostics = function()
	-- Publish diagnostics from the language servers.
	vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
		underline = true,
		update_in_insert = false,
		virtual_text = { spacing = 4, prefix = "●" },
		severity_sort = true,
	})

	for type, icon in pairs(g_diag_signs) do
		local hl = "DiagnosticSign" .. type
		vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
	end
end

refactoring.setup()

hook_lsp_diagnostics()

null_ls.setup {
	on_attach = function(client, bufnr)
		if client.server_capabilities.documentFormattingProvider then
			if client.name == "null-ls" and is_null_ls_formatting_enabed(bufnr)
				or client.name ~= "null-ls"
			then
				vim.api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr()")
			else
				vim.api.nvim_buf_set_option(bufnr, "formatexpr", "")
			end
		end
	end
}

-- TODO: are all of those works with which_key?
-- Tree sitter config
treesitter_configs.setup {
	autotag = { enable = true },
	context_commentstring = { enable = true, enable_autocmd = false },
	highlight = {
		enable = true,
		disable = function(_, bufnr) return vim.b[bufnr].large_buf end,
	},
	incremental_selection = { enable = true },
	indent = { enable = true },
	textobjects = {
		select = {
			enable = true,
			lookahead = true,
			keymaps = {
				["ak"] = { query = "@block.outer", desc = "around block" },
				["ik"] = { query = "@block.inner", desc = "inside block" },
				["ac"] = { query = "@class.outer", desc = "around class" },
				["ic"] = { query = "@class.inner", desc = "inside class" },
				["a?"] = { query = "@conditional.outer", desc = "around conditional" },
				["i?"] = { query = "@conditional.inner", desc = "inside conditional" },
				["af"] = { query = "@function.outer", desc = "around function " },
				["if"] = { query = "@function.inner", desc = "inside function " },
				["al"] = { query = "@loop.outer", desc = "around loop" },
				["il"] = { query = "@loop.inner", desc = "inside loop" },
				["aa"] = { query = "@parameter.outer", desc = "around argument" },
				["ia"] = { query = "@parameter.inner", desc = "inside argument" },
			},
		},
		move = {
			enable = true,
			set_jumps = true,
			goto_next_start = {
				["]k"] = { query = "@block.outer", desc = "Next block start" },
				["]f"] = { query = "@function.outer", desc = "Next function start" },
				["]a"] = { query = "@parameter.inner", desc = "Next argument start" },
			},
			goto_next_end = {
				["]K"] = { query = "@block.outer", desc = "Next block end" },
				["]F"] = { query = "@function.outer", desc = "Next function end" },
				["]A"] = { query = "@parameter.inner", desc = "Next argument end" },
			},
			goto_previous_start = {
				["[k"] = { query = "@block.outer", desc = "Previous block start" },
				["[f"] = { query = "@function.outer", desc = "Previous function start" },
				["[a"] = { query = "@parameter.inner", desc = "Previous argument start" },
			},
			goto_previous_end = {
				["[K"] = { query = "@block.outer", desc = "Previous block end" },
				["[F"] = { query = "@function.outer", desc = "Previous function end" },
				["[A"] = { query = "@parameter.inner", desc = "Previous argument end" },
			},
		},
		swap = {
			enable = true,
			swap_next = {
				[">K"] = { query = "@block.outer", desc = "Swap next block" },
				[">F"] = { query = "@function.outer", desc = "Swap next function" },
				[">A"] = { query = "@parameter.inner", desc = "Swap next argument" },
			},
			swap_previous = {
				["<K"] = { query = "@block.outer", desc = "Swap previous block" },
				["<F"] = { query = "@function.outer", desc = "Swap previous function" },
				["<A"] = { query = "@parameter.inner", desc = "Swap previous argument" },
			},
		},
	},
}

vim.o.foldmethod = "expr"
vim.o.foldexpr = "nvim_treesitter#foldexpr()"

vim.o.foldenable = false
vim.o.foldlevel = 99

which_key.register({
	g = {
		name = "Go",
		H = {
			"<cmd>TSHighlightCapturesUnderCursor<cr>", "Show Tree-sitter Captures"
		},
	},
	t = {
		name = "Toggle",
		p = { "<cmd>TSPlaygroundToggle<cr>", "Toggle Tree-sitter Playground" }
	}
}, { mode = "n", noremap = true, silent = true })

-- Auto completion defaults
cmp.setup(g_cmp_setup)

-- TODO: Fix completeion for enter, fills odd.
-- Use completion source for `/` (if you enabled `native_menu`, this won't work anymore).
for _, cmd_type in ipairs({ '/', '?' }) do
	cmp.setup.cmdline(cmd_type, {
		mapping = cmp.mapping.preset.cmdline(),
		formatting = {
			fields = { "abbr" },
		},
		sources = cmp.config.sources({
			{ name = 'buffer' },
		}),
	})
end

cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	formatting = {
		fields = { "abbr" },
	},
	sources = cmp.config.sources({
		{ name = 'path' },
	}, {
		{ name = 'cmdline' },
	}, {
		{ name = 'cmdline_history' },
	}, {
		{ name = 'buffer' },
	}),
})

-- Trouble
trouble.setup {
	-- position = "bottom", -- position of the list can be: bottom, top, left, right
	-- height = 10, -- height of the trouble list when position is top or bottom
	-- width = 50, -- width of the list when position is left or right
	-- icons = true, -- use devicons for filenames
	-- mode = "workspace_diagnostics", -- "workspace_diagnostics", "document_diagnostics", "quickfix", "lsp_references", "loclist"
	-- fold_open = "", -- icon used for open folds
	-- fold_closed = "", -- icon used for closed folds
	-- group = true, -- group results by file
	-- padding = true, -- add an extra new line on top of the list
	action_keys = {
		-- key mappings for actions in the trouble list
		-- map to {} to remove a mapping, for example:
		-- close = {},
		close = "q",            -- close the list
		cancel = "<esc>",       -- cancel the preview and get back to your last window / buffer / cursor
		refresh = "r",          -- manually refresh
		jump = { "<cr>", "<tab>" }, -- jump to the diagnostic or open / close folds
		open_split = { "S" },   -- open buffer in new split
		open_vsplit = { "s" },  -- open buffer in new vsplit
		open_tab = { "<c-t>" }, -- open buffer in new tab
		jump_close = { "o" },   -- jump to the diagnostic and close the list
		toggle_mode = "m",      -- toggle between "workspace" and "document" diagnostics mode
		toggle_preview = "P",   -- toggle auto_preview
		hover = "K",            -- opens a small popup with the full multiline message
		preview = "p",          -- preview the diagnostic location
		close_folds = { "zC", "zc" }, -- close all folds
		open_folds = { "zO", "zo" }, -- open all folds
		toggle_fold = { "zA", "za" }, -- toggle fold of current file
		previous = "k",         -- preview item
		next = "j"              -- next item
	},
	-- indent_lines = true, -- add an indent guide below the fold icons
	-- auto_open = false, -- automatically open the list when you have diagnostics
	-- auto_close = false, -- automatically close the list when you have no diagnostics
	auto_preview = false, -- automatically preview the location of the diagnostic. <esc> to close preview and go back to last window
	-- auto_fold = false, -- automatically fold a file trouble list at creation
	-- auto_jump = {"lsp_definitions"}, -- for the given modes, automatically jump if there is only a single result
	-- signs = {
	-- 		-- icons / text used for a diagnostic
	-- 		error = "",
	-- 		warning = "",
	-- 		hint = "",
	-- 		information = "",
	-- 		other = "﫠"
	-- },
	-- use_diagnostic_signs = false -- enabling this will use the signs defined in your lsp client
}

-- Inlay hints
inlayhints.setup()

-- LSP Progress to screen
lspecho.setup()

which_key.register({
	t = {
		name = "Toggle",
		t = { "<cmd>:TroubleToggle<cr>", "Toggle Trouble" },
	},
}, { mode = "n", prefix = "<leader>", silent = true })

vim.cmd.dxvim = vim.cmd.dxvim.table_merge(vim.cmd.dxvim, {
	enable_lsp = dxvim_enable_lsp,
	update_lsp = dxvim_update_lsp,
	update_lsp_cmp_setup = dxvim_update_lsp_cmp_setup,
	lsp_on_attach_hook = dxvim_lsp_on_attach_hook,
})
