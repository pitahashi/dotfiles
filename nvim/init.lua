vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Options
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.wrap = true
vim.opt.confirm = true
vim.opt.ruler = true
vim.opt.termguicolors = true
vim.opt.updatetime = 250
vim.opt.winborder = "rounded"

vim.opt.laststatus = 2
vim.opt.cmdheight = 1
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes:1"
vim.opt.scrolloff = 10
vim.opt.showcmd = true
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.backup = false
vim.opt.clipboard = "unnamedplus"

vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.showmode = true
vim.opt.shortmess:append("I")
vim.opt.fillchars:append({ lastline = " " })

vim.api.nvim_create_user_command("CopyMessages", function()
	local messages = vim.fn.execute("messages")
	vim.fn.setreg("+", messages)
	print("Copied Messages to clipboard")
end, {
	desc = "Copy NVIM Messages to clipboard",
})

vim.api.nvim_create_user_command("CopyAll", function()
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	vim.fn.setreg("+", table.concat(lines, "\n"))
end, {
	desc = "Copy the entire buffer to clipboard",
})

require("vim._core.ui2").enable({})

-- Keymaps
local keymap_opts = { noremap = true, silent = true }
vim.keymap.set("n", "<leader>cm", "<cmd>CopyMessages<cr>", { desc = "Copy messages" })
vim.keymap.set("i", "jj", "<esc>")
vim.keymap.set("n", "<esc><esc>", ":nohl<CR>")
vim.keymap.set("n", "<C-u>", "15k", keymap_opts)
vim.keymap.set("n", "<C-d>", "15j", keymap_opts)
vim.keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split vertically" })
vim.keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split horizontally" })

-- Plugins and UI
require("config.plugins")
require("config.mini")

-- LSP, diagnostics
vim.lsp.config("*", {
	capabilities = require("mini.completion").get_lsp_capabilities(),
})

vim.diagnostic.config({
	virtual_text = { spacing = 2, prefix = "●" },
	float = {
		border = "rounded",
		header = "",
		prefix = "",
		focusable = true,
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "",
			[vim.diagnostic.severity.WARN] = "",
			[vim.diagnostic.severity.INFO] = "",
			[vim.diagnostic.severity.HINT] = "󰌵",
		},
	},
	underline = true,
	update_in_insert = false,
	severity_sort = true,
})

local severity = vim.diagnostic.severity

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
	callback = function(args)
		local bufnr = args.buf
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client then
			client.server_capabilities.semanticTokensProvider = nil
		end

		local map = function(mode, lhs, rhs, desc)
			vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
		end

		map("n", "gd", vim.lsp.buf.definition, "LSP: definition")
		map("n", "gD", vim.lsp.buf.declaration, "LSP: declaration")
		map("n", "gi", vim.lsp.buf.implementation, "LSP: implementation")
		map("n", "gR", vim.lsp.buf.references, "LSP: references")
		map("n", "K", vim.lsp.buf.hover, "LSP: hover")
		map("n", "<leader>rn", vim.lsp.buf.rename, "LSP: rename")
		map("n", "<leader>ca", vim.lsp.buf.code_action, "LSP: code action")
		map("n", "<leader>ds", function()
			vim.diagnostic.open_float({ focusable = true })
		end, "Diag: float")
		map("n", "[d", function()
			vim.diagnostic.jump({ count = -1 })
		end, "Diag: prev")
		map("n", "]d", function()
			vim.diagnostic.jump({ count = 1 })
		end, "Diag: next")
		map("n", "[e", function()
			vim.diagnostic.jump({ count = -1, severity = severity.ERROR })
		end, "Diag Error: prev")
		map("n", "]e", function()
			vim.diagnostic.jump({ count = 1, severity = severity.ERROR })
		end, "Diag Error: next")
		if _G.MiniClue then
			MiniClue.ensure_buf_triggers(bufnr)
		end
	end,
})

vim.lsp.config("lua_ls", {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = {
		".luarc.json",
		".luarc.jsonc",
		".git",
	},
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				checkThirdParty = false,
			},
			telemetry = {
				enable = false,
			},
		},
	},
})

vim.lsp.config("ts", {
	cmd = { "typescript-language-server", "--stdio" },
	init_options = {
		hostInfo = "neovim",
	},
	before_init = function(_, config)
		-- Prefer workspace TypeScript; resolve mise's fallback without a fixed version path.
		local result = vim.system({ "mise", "where", "npm:typescript" }, { text = true }):wait()
		if result.code ~= 0 then
			return
		end
		for _, relative in ipairs({
			"node_modules/typescript/lib/tsserver.js",
			"lib/node_modules/typescript/lib/tsserver.js",
		}) do
			local path = vim.fs.joinpath(vim.trim(result.stdout), relative)
			if vim.fn.filereadable(path) == 1 then
				config.init_options.tsserver = { fallbackPath = path }
				break
			end
		end
	end,
	filetypes = {
		"javascript",
		"typescript",
		"javascriptreact",
		"typescriptreact",
	},
	root_markers = {
		"pnpm-lock.yaml",
		"yarn.lock",
		"bun.lock",
		"package-lock.json",
		".git",
	},
})

vim.lsp.config("gopls", {
	cmd = { "gopls" },
	filetypes = { "go", "gomod", "gowork", "gotmpl" },
	root_markers = {
		"go.work",
		"go.mod",
		".git",
	},
})

vim.lsp.config("intelephense", {
	cmd = { "intelephense", "--stdio" },
	filetypes = { "php" },
	root_markers = {
		"composer.json",
		".git",
	},
})

vim.lsp.enable({
	"lua_ls",
	"ts",
	"gopls",
	"intelephense",
})

-- Autocommands
vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
		vim.opt_local.formatoptions:remove({ "r", "o" })
	end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
})
