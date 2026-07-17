return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"mason-org/mason.nvim",
			"mason-org/mason-lspconfig.nvim",
			{ "folke/lazydev.nvim", ft = "lua", opts = {} },
		},
		config = function()
			vim.lsp.config("*", {
				capabilities = require("cmp_nvim_lsp").default_capabilities(),
			})

			vim.diagnostic.config({
				virtual_text = { spacing = 2, source = "if_many", prefix = "●" },
				float = {
					border = "rounded",
					source = "if_many",
					header = "",
					prefix = "",
					focusable = false,
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

			vim.lsp.config("lua_ls", {
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							checkThirdParty = false,
						},
						telemetry = { enable = false },
					},
				},
			})

			require("mason").setup()

			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"ts_ls",
					"html",
					"cssls",
				},
				automatic_enable = true,
			})

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
					map("n", "<leader>ds", vim.diagnostic.open_float, "Diag: float")
					map("n", "[d", function()
						vim.diagnostic.jump({ count = -1 })
					end, "Diag: prev")
					map("n", "]d", function()
						vim.diagnostic.jump({ count = 1 })
					end, "Diag: next")
				end,
			})
		end,
	},
}
