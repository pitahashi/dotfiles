return {
	"romgrk/barbar.nvim",
	event = "VeryLazy",
	dependencies = { "nvim-mini/mini.icons" },
	keys = {
		{ "<Tab>", "<cmd>BufferNext<cr>", desc = "Next Buffer" },
		{ "<S-Tab>", "<cmd>BufferPrevious<cr>", desc = "Prev Buffer" },
		{ "<leader>bd", "<cmd>BufferClose<cr>", desc = "Close Buffer" },
		{ "<leader>bo", "<cmd>BufferCloseAllButCurrent<cr>", desc = "Close other Buffers" },
	},
}
