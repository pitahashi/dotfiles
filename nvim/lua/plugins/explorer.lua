return {
	"nvim-mini/mini.files",
	version = false,
	keys = {
		{
			"<leader>e",
			function()
				require("mini.files").open()
			end,
			desc = "Find files",
		},
	},
	config = function()
		require("mini.files").setup()
	end,
}
