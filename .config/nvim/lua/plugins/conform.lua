return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = function()
		local function has_prettier_config(bufnr)
			local path = vim.api.nvim_buf_get_name(bufnr)
			local dir = vim.fs.dirname(path)

			return vim.fs.find({
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
			}, {
				path = dir,
				upward = true,
			})[1] ~= nil
		end

		local function js_formatter(bufnr)
			if has_prettier_config(bufnr) then
				return { "prettier" }
			end

			return { "oxfmt" }
		end

		return {
			formatters_by_ft = {
				lua = { "stylua" },
				javascript = js_formatter,
				javascriptreact = js_formatter,
				typescript = js_formatter,
				typescriptreact = js_formatter,
			},
		}
	end,
}
