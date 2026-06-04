return {
	"craftzdog/solarized-osaka.nvim",
	lazy = false,
	priority = 1000,

	opts = {
		transparent = false,

		styles = {
			comments = { italic = false },
			keywords = { italic = false },
			functions = {},
			variables = {},
			sidebars = "dark",
			floats = "dark",
		},

		on_highlights = function(hl, c)
			-- 行番号
			hl.LineNr = {
				fg = c.base01,
			}

			hl.CursorLineNr = {
				fg = c.yellow,
				bold = true,
			}

			-- 現在行
			hl.CursorLine = {
				bg = c.base02,
			}

			-- 選択範囲
			hl.Visual = {
				bg = c.base03,
			}

			-- 検索
			hl.Search = {
				fg = c.base3,
				bg = c.orange,
			}

			hl.IncSearch = {
				fg = c.base3,
				bg = c.red,
			}

			-- コメントを少し抑える
			hl.Comment = {
				fg = c.base01,
				italic = false,
			}

			-- Diagnostic
			hl.DiagnosticVirtualTextError = {
				fg = c.red,
				bg = "NONE",
			}

			hl.DiagnosticVirtualTextWarn = {
				fg = c.yellow,
				bg = "NONE",
			}

			hl.DiagnosticVirtualTextInfo = {
				fg = c.blue,
				bg = "NONE",
			}

			hl.DiagnosticVirtualTextHint = {
				fg = c.cyan,
				bg = "NONE",
			}

			-- Telescope
			hl.TelescopeBorder = {
				fg = c.base01,
			}

			hl.TelescopePromptBorder = {
				fg = c.base01,
			}

			hl.TelescopeResultsBorder = {
				fg = c.base01,
			}

			hl.TelescopePreviewBorder = {
				fg = c.base01,
			}
		end,
	},

	config = function(_, opts)
		require("solarized-osaka").setup(opts)
		vim.cmd.colorscheme("solarized-osaka")
	end,
}
