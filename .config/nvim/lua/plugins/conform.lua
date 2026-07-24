local util = require("conform.util")
local function js_formatter(bufnr)
	if
		util.root_file({
			".prettierrc",
			".prettierrc.json",
			".prettierrc.yaml",
			".prettierrc.yml",
			".prettierrc.js",
			".prettierrc.cjs",
			".prettierrc.mjs",
			"prettier.config.js",
			"prettier.config.cjs",
			"prettier.config.mjs",
			"prettier.config.ts",
		})(bufnr)
	then
		return { "prettier" }
	end

	return { "oxfmt" }
end

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
			javascriptreact = js_formatter,
			typescript = js_formatter,
			typescriptreact = js_formatter,
			javascript = js_formatter,
		},
	},
}
