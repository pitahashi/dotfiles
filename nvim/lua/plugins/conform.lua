return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = "ConformInfo",
	config = function()
		local function js_formatter(bufnr)
			local path = vim.api.nvim_buf_get_name(bufnr)
			local config = vim.fs.find({
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
			}, { path = vim.fs.dirname(path), upward = true })[1]
			return { config and "prettier" or "oxfmt" }
		end
		require("conform").setup({
			format_on_save = {
				timeout_ms = 500,
				lsp_format = "fallback",
			},
			formatters_by_ft = {
				lua = { "stylua" },
				javascript = js_formatter,
				javascriptreact = js_formatter,
				typescript = js_formatter,
				typescriptreact = js_formatter,
			},
		})
	end,
}
