local ignore_globs = {
	"**/node_modules/**",
	"**/.next/**",
	"**/.vite-hooks/**",
	"**/.wrangler/**",
	"**/dist/**",
}

return {
	"folke/snacks.nvim",
	keys = {
		{
			"ff",
			function()
				Snacks.picker.files()
			end,
			desc = "Find files",
		},
		{
			"<leader>fb",
			function()
				Snacks.picker.buffers()
			end,
			desc = "Find buffers",
		},
		{
			"<leader>fg",
			function()
				Snacks.picker.grep()
			end,
			desc = "Search project",
		},
		{
			"<leader>fe",
			function()
				Snacks.picker.diagnostics({ severity = vim.diagnostic.severity.ERROR })
			end,
			desc = "Find errors in project",
		},
		{
			"gf",
			function()
				Snacks.picker.git_status()
			end,
			desc = "Find changed Git files",
		},
	},
	opts = {
		picker = {
			sources = {
				files = {
					hidden = true,
					ignored = true,
					exclude = ignore_globs,
				},
				grep = {
					exclude = ignore_globs,
				},
			},
		},
	},
}
