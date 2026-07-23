return {
	{
		"nvim-mini/mini.icons",
		version = "*",
		opts = {},
		lazy = false,
		keys = {
			{
				"<Tab>",
				"<cmd>BufferNext<cr>",
				desc = "Next Buffer",
			},
		},
		config = function()
			require("mini.icons").setup()
			MiniIcons.mock_nvim_web_devicons()
		end,
	},
}
