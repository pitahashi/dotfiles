return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			go = { "gofmt" },
			html = { "oxfmt" },
			python = { "isort", "black" },
			rust = { "rustfmt", lsp_format = "fallback" },
			css = { "oxfmt" },
			javascriptreact = { "oxfmt" },
			typescript = { "oxfmt" },
			typescriptreact = { "oxfmt" },
			javascript = { "oxfmt" },
		},
	},
}
