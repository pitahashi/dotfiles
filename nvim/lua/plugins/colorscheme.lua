return {
	"rose-pine/neovim",
	name = "rose-pine",
	cond = not vim.g.vscode,
	priority = 1000,
	config = function()
		require("rose-pine").setup({
			variant = "moon",
			dark_variant = "moon",
			styles = {
				italic = false,
				transparency = true,
			},
		})
		vim.cmd("colorscheme rose-pine")
	end,
}
