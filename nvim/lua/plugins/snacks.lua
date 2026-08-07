return {
	"folke/snacks.nvim",
	lazy = false,
	opts = {
		indent = {
			enabled = true,
			char = "│",
			hl = {
				"SnacksIndent1",
				"SnacksIndent2",
			},
			scope = {
				enabled = true, -- enable highlighting the current scope
				priority = 200,
				char = "│",
				underline = false, -- underline the start of the scope
				only_current = false, -- only show scope in the current window
				hl = "SnacksIndentScope", ---@type string|string[] hl group for scopes
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
}
