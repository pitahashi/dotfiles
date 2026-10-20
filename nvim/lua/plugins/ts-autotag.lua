return {
	"windwp/nvim-ts-autotag",
	ft = { "html", "xml", "astro", "javascript", "javascriptreact", "typescript", "typescriptreact" },
	opts = {
		opts = { enable_close = true, enable_rename = true, enable_close_on_slash = false },
		per_filetype = { html = { enable_close = true }, xml = { enable_rename = true } },
		aliases = { astro = "html" },
	},
}
