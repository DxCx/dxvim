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

-- Enable spell checking.
vim.api.nvim_create_autocmd(
	{ "BufRead", "BufNewFile" },
	{
		pattern = { "*.txt", "*.md", "*.tex" },
		command = "setlocal spell",
	}
)
