vim.g.mapleader = ","
vim.opt.termguicolors = true
vim.opt.updatetime = 10 -- Update UI every 10ms
vim.opt.timeoutlen = 250
-- vim.opt.ttimeoutlen = 0

vim.opt.expandtab = false
vim.opt.encoding = "utf-8"
vim.opt.autoindent = true
vim.opt.cursorline = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = true
vim.opt.wrapscan = true
vim.opt.linebreak = true
vim.opt.list = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.backspace = "indent,eol,start"
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.inccommand = "nosplit"

vim.opt.history = 1000
vim.opt.undolevels = 1000
vim.opt.wildignore = "*.swp,*.bak,*.pyc,*.class"
vim.opt.hidden = true
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.spelllang = "en_us"

-- Stop the sign column from flashing in/out with gitsigns.
vim.opt.signcolumn = "yes"

-- We're professionals here.
vim.opt.mouse = ""

local dxvim = {}

-- Enable spell checking.
vim.api.nvim_create_autocmd(
	{ "BufRead", "BufNewFile" },
	{
		pattern = { "*.txt", "*.md", "*.tex" },
		command = "setlocal spell",
	}
)

---The symbol to remove key in misc.merge.
dxvim._table_nope_mark = vim.NIL

dxvim.table_merge = function(tbl1, tbl2)
	local is_dict1 = type(tbl1) == 'table' and (not vim.tbl_islist(tbl1) or vim.tbl_isempty(tbl1))
	local is_dict2 = type(tbl2) == 'table' and (not vim.tbl_islist(tbl2) or vim.tbl_isempty(tbl2))
	if is_dict1 and is_dict2 then
		local new_tbl = {}
		for k, v in pairs(tbl2) do
			if tbl1[k] ~= dxvim._table_nope_mark then
				new_tbl[k] = dxvim.table_merge(tbl1[k], v)
			end
		end
		for k, v in pairs(tbl1) do
			if tbl2[k] == nil then
				if v ~= dxvim._table_nope_mark then
					new_tbl[k] = dxvim.table_merge(v, {})
				else
					new_tbl[k] = nil
				end
			end
		end
		return new_tbl
	end

	if tbl1 == dxvim._table_nope_mark then
		return nil
	elseif tbl1 == nil then
		return dxvim.table_merge(tbl2, {})
	elseif vim.tbl_islist(tbl1) then
		assert(vim.tbl_islist(tbl2), "both have to be lists")
		return vim.list_extend(vim.deepcopy(tbl1), tbl2)
	else
		return tbl1
	end
end

dxvim.is_maximized = function()
	return false
end

vim.cmd.dxvim = dxvim
