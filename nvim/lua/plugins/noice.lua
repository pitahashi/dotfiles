return {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify",
	},
	opts = {
		messages = {
			view_search = "mini",
		},
		routes = {
			{
				filter = {
					event = "notify",
					warning = true,
					find = "failed to run generator.*is not executable",
				},
				opts = { skip = true },
			},
		},
		views = {
			cmdline_popup = {
				position = {
					row = "50%",
					col = "50%",
				},
				size = {
					width = 60,
					height = "auto",
				},
				border = {
					style = "rounded",
				},
			},
		},
		lsp = {
			progress = { enabled = true },
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = true,
				["cmp.entry.get_documentation"] = true,
			},
			hover = { enabled = true },
			signature = { enabled = true },
		},
		presets = {
			bottom_search = true, -- /検索をコマンドライン下部に表示
			command_palette = true, -- : コマンドをポップアップで表示
			long_message_to_split = true, -- 長いメッセージを split に流す
			inc_rename = false,
			lsp_doc_border = true, -- hover/signature にボーダーを付ける
		},
	},
	keys = {
		{
			"<leader>nd",
			function()
				require("noice").cmd("dismiss")
			end,
			desc = "Noice: dismiss all",
		},
		{
			"<leader>nh",
			function()
				require("noice").cmd("history")
			end,
			desc = "Noice: message history",
		},
		{
			"<S-Enter>",
			function()
				require("noice").redirect(vim.fn.getcmdline())
			end,
			mode = "c",
			desc = "Noice: redirect cmdline to split",
		},
	},
}
