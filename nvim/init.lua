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
vim.opt.colorcolumn = "80"
vim.opt.ruler = true
vim.opt.termguicolors = true
vim.opt.updatetime = 250
vim.opt.winborder = "rounded"

vim.opt.laststatus = 3
vim.opt.cmdheight = 0
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
require("vim._core.ui2").enable({})

-- Keymaps
local keymap_opts = { noremap = true, silent = true }
vim.keymap.set("i", "jj", "<esc>")
vim.keymap.set("n", "<esc><esc>", ":nohl<CR>")
vim.keymap.set("n", "<C-u>", "15k", keymap_opts)
vim.keymap.set("n", "<C-d>", "15j", keymap_opts)
vim.keymap.set("n", "<leader>sv", "<C-w>v")
vim.keymap.set("n", "<leader>sh", "<C-w>s")

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Plugins
require("lazy").setup({
	spec = {
		{
			"windwp/nvim-autopairs",
			event = "InsertEnter",
			version = "0.11.0",
			config = true,
		},
		{
			"windwp/nvim-ts-autotag",
			opts = {
				opts = {
					enable_close = true,
					enable_rename = true,
					enable_close_on_slash = false,
				},
				per_filetype = {
					html = { enable_close = true },
					xml = { enable_rename = true },
				},
				aliases = { astro = "html" },
			},
		},
		{
			"romgrk/barbar.nvim",
			event = "VeryLazy",
			dependencies = { "nvim-mini/mini.icons" },
			keys = {
				{ "<Tab>", "<cmd>BufferNext<cr>", desc = "Next Buffer" },
				{ "<S-Tab>", "<cmd>BufferPrevious<cr>", desc = "Prev Buffer" },
				{ "<leader>bd", "<cmd>BufferClose<cr>", desc = "Close Buffer" },
				{ "<leader>bo", "<cmd>BufferCloseAllButCurrent<cr>", desc = "Close other Buffers" },
			},
		},
		{
			"j-hui/fidget.nvim",
			cond = not vim.g.vscode,
			opts = {},
		},
		{
			"hrsh7th/nvim-cmp",
			event = "InsertEnter",
			dependencies = {
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-path",
				"hrsh7th/cmp-buffer",
				"L3MON4D3/LuaSnip",
				"saadparwaiz1/cmp_luasnip",
				"rafamadriz/friendly-snippets",
			},
			config = function()
				local cmp = require("cmp")
				local luasnip = require("luasnip")

				require("luasnip.loaders.from_vscode").lazy_load()

				cmp.setup({
					snippet = {
						expand = function(args)
							luasnip.lsp_expand(args.body)
						end,
					},
					window = {
						documentation = { border = "rounded" },
					},
					completion = {
						completeopt = "menu,menuone,noinsert",
					},
					mapping = cmp.mapping.preset.insert({
						["<C-Space>"] = cmp.mapping.complete(),
						["<CR>"] = cmp.mapping.confirm({ select = true }),
						["<Tab>"] = cmp.mapping(function(fallback)
							if cmp.visible() then
								cmp.select_next_item()
							elseif luasnip.expand_or_jumpable() then
								luasnip.expand_or_jump()
							else
								fallback()
							end
						end, { "i", "s" }),
						["<S-Tab>"] = cmp.mapping(function(fallback)
							if cmp.visible() then
								cmp.select_prev_item()
							elseif luasnip.jumpable(-1) then
								luasnip.jump(-1)
							else
								fallback()
							end
						end, { "i", "s" }),
						["<C-e>"] = cmp.mapping.abort(),
						["<C-d>"] = cmp.mapping.scroll_docs(4),
						["<C-u>"] = cmp.mapping.scroll_docs(-4),
					}),
					sources = cmp.config.sources({
						{ name = "nvim_lsp" },
						{ name = "luasnip" },
						{ name = "path" },
						{ name = "buffer" },
					}),
				})
			end,
		},
		{
			"craftzdog/solarized-osaka.nvim",
			name = "solarized-osaka",
			cond = not vim.g.vscode,
			lazy = false,
			priority = 1000,
			config = function()
				require("solarized-osaka").setup({
					styles = {
						italic = false,
						transparency = true,
						comments = { italic = true },
						keywords = { italic = true },
					},
				})
				vim.cmd("colorscheme solarized-osaka")
			end,
		},
		{
			"kylechui/nvim-surround",
			version = "^4.0.0", -- Use for stability; omit to use `main` branch for the latest features
			event = "VeryLazy",
		},
		{
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
		},
		{
			"lewis6991/gitsigns.nvim",
			event = { "BufReadPost", "BufNewFile" },
			opts = {
				current_line_blame = true,
			},
			keys = {
				{
					"]h",
					function()
						require("gitsigns").nav_hunk("next")
					end,
					desc = "Git: next hunk",
				},
				{
					"[h",
					function()
						require("gitsigns").nav_hunk("prev")
					end,
					desc = "Git: prev hunk",
				},
				{
					"<leader>hs",
					function()
						require("gitsigns").stage_hunk()
					end,
					desc = "Git: stage hunk",
				},
				{
					"<leader>hr",
					function()
						require("gitsigns").reset_hunk()
					end,
					desc = "Git: reset hunk",
				},
				{
					"<leader>hb",
					function()
						require("gitsigns").toggle_current_line_blame()
					end,
					desc = "Git: toggle blame",
				},
			},
		},
		{
			"nvim-mini/mini.icons",
			version = "*",
			opts = {},
			lazy = false,
			keys = {
				{ "<Tab>", "<cmd>BufferNext<cr>", desc = "Next Buffer" },
			},
			config = function()
				require("mini.icons").setup()
				MiniIcons.mock_nvim_web_devicons()
			end,
		},
		{
			"kdheepak/lazygit.nvim",
			lazy = true,
			cmd = {
				"LazyGit",
				"LazyGitConfig",
				"LazyGitCurrentFile",
				"LazyGitFilter",
				"LazyGitFilterCurrentFile",
			},
			dependencies = { "nvim-lua/plenary.nvim" },
			keys = {
				{ "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
			},
		},
		{
			"stevearc/oil.nvim",
			cond = not vim.g.vscode,
			opts = {},
			dependencies = { { "nvim-mini/mini.icons", opts = {} } },
			lazy = false,
			config = function()
				require("oil").setup({
					view_options = {
						show_hidden = true,
					},
				})
				vim.keymap.set("n", "-", "<cmd>Oil<cr>", { desc = "Open parent directory" })
			end,
		},
		{
			"folke/snacks.nvim",
			lazy = false,
			opts = {
				indent = {
					enabled = true,
					char = "│",
					hl = { "SnacksIndent1", "SnacksIndent2" },
					scope = {
						enabled = true,
						priority = 200,
						char = "│",
						underline = false,
						only_current = false,
						hl = "SnacksIndentScope",
					},
					chunk = {
						enabled = true,
						char = {
							corner_top = "╭",
							corner_bottom = "╰",
							horizontal = "─",
							vertical = "│",
							arrow = ">",
						},
						hl = "SnacksIndentChunk",
					},
				},
				picker = {
					enabled = false,
					hidden = true,
					ignored = true,
					exclude = {
						"node_modules",
						".next",
						".vite-hooks",
						".wrangler",
						"dist",
					},
					sources = {
						files = {
							hidden = true,
							ignored = true,
						},
					},
				},
			},
			keys = {
				{
					"ff",
					function()
						require("snacks").picker.files()
					end,
					desc = "Find files",
				},
				{
					"fb",
					function()
						require("snacks").picker.buffers()
					end,
					desc = "Find files",
				},
				{
					"fg",
					function()
						require("snacks").picker.grep()
					end,
				},
				{
					"fe",
					function()
						require("snacks").picker.diagnostics({ severity = vim.diagnostic.severity.ERROR })
					end,
					desc = "Find errors in project",
				},
				{
					"<leader>od",
					function()
						require("snacks").picker.pick({
							source = "dirs",
							finder = "proc",
							cmd = "fd",
							args = {
								"--type",
								"d",
								"--hidden",
								"--exclude",
								".git",
							},
							transform = function(item)
								item.file = item.text
								item.dir = true
								return item
							end,
							actions = {
								confirm = function(picker, item)
									picker:close()
									require("oil").open(vim.fn.fnamemodify(item.file, ":p"))
								end,
							},
						})
					end,
					desc = "Oil dirs",
				},
				{
					"gf",
					function()
						require("snacks").picker.git_status({ untracked = true, ignored = false })
					end,
					desc = "Find Git Files in project",
				},
			},
		},
		{
			"nvim-lualine/lualine.nvim",
			event = "VeryLazy",
			opts = {
				options = {
					theme = "auto",
					globalstatus = true,
				},
				sections = {
					lualine_a = {
						{
							"mode",
							fmt = function(str)
								return str:sub(1, 1)
							end,
						},
					},
					lualine_b = { "branch", "diff" },
					lualine_c = { "filename" },
					lualine_x = { "diagnostics", "filetype" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
			},
		},
		{
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
		},
	},
	{
		"folke/which-key.nvim",
		cond = not vim.g.vscode,
		event = "VeryLazy",
		opts = {
			delay = 500, -- ms before popup shows (default uses timeoutlen)
		},
	},
	checker = { enabled = true, notify = false, frequency = 3600 },
})

-- LSP and diagnostics
vim.lsp.config("*", {
	capabilities = require("cmp_nvim_lsp").default_capabilities(),
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

vim.lsp.enable({
	"lua_ls",
	"ts_ls",
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

vim.api.nvim_create_autocmd("User", {
	pattern = "LazyCheck",
	callback = function()
		local checker = require("lazy.manage.checker")
		if #checker.updated > 0 then
			require("lazy").update({ show = false })
		end
	end,
})
