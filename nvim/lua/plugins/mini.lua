return {
	"nvim-mini/mini.nvim",
	config = function()
		require("mini.icons").setup()
		require("mini.pairs").setup()
		require("mini.bufremove").setup()
		require("mini.tabline").setup()
		require("mini.git").setup()
		require("mini.diff").setup({ view = { style = "sign" } })
		require("mini.files").setup({ options = { use_as_default_explorer = true } })
		require("mini.indentscope").setup({
			symbol = "│",
			draw = { animation = require("mini.indentscope").gen_animation.none() },
		})

		require("mini.surround").setup({
			mappings = {
				add = "ys",
				delete = "ds",
				replace = "cs",
				find = "",
				find_left = "",
				highlight = "",
				suffix_last = "",
				suffix_next = "",
			},
			search_method = "cover_or_next",
		})
		vim.keymap.del("x", "ys")
		vim.keymap.set(
			"x",
			"S",
			":<C-u>lua MiniSurround.add('visual')<CR>",
			{ silent = true, desc = "Surround selection" }
		)
		vim.keymap.set("n", "yss", "ys_", { remap = true, desc = "Surround line" })

		local snippets = require("mini.snippets")
		snippets.setup({
			snippets = { snippets.gen_loader.from_lang() },
			mappings = { jump_next = "", jump_prev = "" },
			expand = {
				match = function(items)
					return snippets.default_match(items, { pattern_fuzzy = "%S+" })
				end,
			},
		})

		local function map(lhs, rhs, desc)
			vim.keymap.set("n", lhs, rhs, { silent = true, desc = desc })
		end
		map("<Tab>", "<cmd>bnext<cr>", "Next buffer")
		map("<S-Tab>", "<cmd>bprevious<cr>", "Previous buffer")
		map("<leader>bd", function()
			MiniBufremove.delete()
		end, "Close buffer")
		map("<leader>bo", function()
			local current = vim.api.nvim_get_current_buf()
			for _, buf in ipairs(vim.api.nvim_list_bufs()) do
				if buf ~= current and vim.bo[buf].buflisted then
					MiniBufremove.delete(buf)
				end
			end
		end, "Close other buffers")
		map("<leader>e", function()
			if not MiniFiles.close() then
				local path = vim.api.nvim_buf_get_name(0)
				MiniFiles.open(vim.uv.fs_stat(path) and path or vim.fn.getcwd())
			end
		end, "File explorer")

		-- Apply/reset the whole hunk under the cursor, matching the former shortcuts.
		local function hunk_action(action)
			local line = vim.api.nvim_win_get_cursor(0)[1]
			local data = MiniDiff.get_buf_data(0)
			for _, hunk in ipairs(data and data.hunks or {}) do
				local first = math.max(hunk.buf_start, 1)
				local last = math.max(first, hunk.buf_start + hunk.buf_count - 1)
				if first <= line and line <= last then
					MiniDiff.do_hunks(0, action, { line_start = first, line_end = last })
					return
				end
			end
		end
		map("<leader>hs", function()
			hunk_action("apply")
		end, "Git: stage hunk")
		map("<leader>hr", function()
			hunk_action("reset")
		end, "Git: reset hunk")
		map("<leader>hb", "<cmd>vertical Git blame -- %<cr>", "Git: show blame")
		map("<leader>hd", function()
			MiniDiff.toggle_overlay()
		end, "Git: toggle diff overlay")

		-- LazyGit is an external program; Neovim's terminal replaces its wrapper plugin.
		vim.api.nvim_create_user_command("LazyGit", function()
			if vim.fn.executable("lazygit") == 0 then
				return vim.notify("lazygit executable was not found", vim.log.levels.ERROR)
			end
			vim.cmd("tabnew")
			local buf = vim.api.nvim_get_current_buf()
			vim.bo[buf].bufhidden = "wipe"
			vim.fn.jobstart({ "lazygit" }, {
				term = true,
				on_exit = function()
					vim.schedule(function()
						if vim.api.nvim_buf_is_valid(buf) then
							vim.api.nvim_buf_delete(buf, { force = true })
						end
					end)
				end,
			})
			vim.cmd("startinsert")
		end, { desc = "Open LazyGit in a terminal tab" })
		map("<leader>lg", "<cmd>LazyGit<cr>", "LazyGit")
	end,
}
