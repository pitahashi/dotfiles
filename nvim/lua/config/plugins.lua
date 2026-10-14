-- mini.deps manages mini.nvim itself and the features mini does not provide.
local package_path = vim.fn.stdpath("data") .. "/site"
local mini_path = package_path .. "/pack/deps/start/mini.nvim"
if not vim.uv.fs_stat(mini_path) then
	vim.api.nvim_echo({ { "Installing mini.nvim…", "MoreMsg" } }, true, {})
	local output = vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/nvim-mini/mini.nvim.git",
		mini_path,
	})
	if vim.v.shell_error ~= 0 then
		error("Failed to install mini.nvim:\n" .. output)
	end
end
vim.cmd("packadd mini.nvim")
require("mini.deps").setup({ path = { package = package_path } })
local add = require("mini.deps").add
add({ source = "nvim-mini/mini.nvim" })

-- Snippet data is consumed by mini.snippets; no LuaSnip/cmp dependency.
add({ source = "rafamadriz/friendly-snippets" })

-- mini.nvim has no formatter runner, parser manager, or automatic tag editor.
add({ source = "stevearc/conform.nvim" })
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
	formatters_by_ft = {
		lua = { "stylua" },
		javascript = js_formatter,
		javascriptreact = js_formatter,
		typescript = js_formatter,
		typescriptreact = js_formatter,
	},
})

add({
	source = "nvim-treesitter/nvim-treesitter",
	checkout = "main",
	hooks = {
		post_checkout = function()
			vim.cmd("TSUpdate")
		end,
	},
})
require("nvim-treesitter").install({
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
})
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("treesitter-start", { clear = true }),
	callback = function(args)
		pcall(vim.treesitter.start, args.buf)
	end,
})

add({ source = "windwp/nvim-ts-autotag" })
require("nvim-ts-autotag").setup({
	opts = { enable_close = true, enable_rename = true, enable_close_on_slash = false },
	per_filetype = { html = { enable_close = true }, xml = { enable_rename = true } },
	aliases = { astro = "html" },
})
