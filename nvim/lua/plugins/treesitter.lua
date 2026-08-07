return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		local parsers = {
			"astro",
			"lua",
			"vim",
			"vimdoc",
			"javascript",
			"typescript",
			"tsx",
			"json",
			"html",
			"sql",
			"css",
			"go",
			"rust",
		}

		require("nvim-treesitter").install(parsers)

		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("treesitter-start", { clear = true }),
			callback = function(args)
				pcall(vim.treesitter.start, args.buf)
			end,
		})
	end,
}
