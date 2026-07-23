vim.lsp.config("ts_ls", {
	cmd = { "typescript-language-server", "--stdio" },
	filetypes = {
		"javascript",
		"typescript",
		"javascriptreact",
		"typescriptreact",
	},
	root_markers = {
		"tsconfig.json",
		"package.json",
		".git",
	},
})
