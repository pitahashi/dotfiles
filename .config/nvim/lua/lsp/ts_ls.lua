vim.lsp.config("ts_ls", {
	cmd = { "typescript-language-server" },
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
