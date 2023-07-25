local ok, _ = pcall(require, 'nord')
if ok then
	vim.cmd [[
		colorscheme nord
	]]
end
