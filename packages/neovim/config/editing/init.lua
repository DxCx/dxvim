local indent = require("ibl")
local todo = require("todo-comments")
local surround = require("nvim-surround")
local comment = require("nvim_comment")

surround.setup()
comment.setup()

-- TODO: Comments enhancement and tracking
todo.setup()

-- indent blankline
vim.opt.list = true
vim.opt.listchars:append "space:⋅"
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
