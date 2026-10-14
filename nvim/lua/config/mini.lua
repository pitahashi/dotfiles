require("mini.icons").setup()
require("mini.pairs").setup()
require("mini.bufremove").setup()
require("mini.tabline").setup()
require("mini.git").setup()
require("mini.diff").setup({ view = { style = "sign" } })
require("mini.files").setup({ options = { use_as_default_explorer = true } })
require("mini.pick").setup()
require("mini.extra").setup()
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
vim.keymap.set("x", "S", ":<C-u>lua MiniSurround.add('visual')<CR>", { silent = true, desc = "Surround selection" })
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
require("mini.completion").setup({
	window = { info = { border = "rounded" }, signature = { border = "rounded" } },
	mappings = { scroll_down = "<C-d>", scroll_up = "<C-u>" },
})
-- Expose friendly-snippets in the completion menu through mini's in-process LSP.
snippets.start_lsp_server()
vim.opt.completeopt = { "menu", "menuone", "noinsert" }
local multistep = require("mini.keymap").map_multistep
multistep("i", "<Tab>", { "pmenu_next", "minisnippets_expand", "minisnippets_next" })
multistep("i", "<S-Tab>", { "pmenu_prev", "minisnippets_prev" })
multistep("i", "<CR>", { "pmenu_accept", "minipairs_cr" })

if not vim.g.vscode then
	vim.opt.background = "dark"
	vim.cmd("colorscheme minispring")
	require("mini.statusline").setup()
	vim.opt.laststatus = 3
	vim.opt.showmode = false
end

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

-- A positive glob includes hidden/ignored files; later exclusions take priority.
local search_globs = {
	"**",
	"!**/.git/**",
	"!**/node_modules/**",
	"!**/.next/**",
	"!**/.vite-hooks/**",
	"!**/.wrangler/**",
	"!**/dist/**",
}
map("ff", function()
	if vim.fn.executable("rg") == 0 then
		return MiniPick.builtin.files()
	end
	local command = { "rg", "--files" }
	for _, glob in ipairs(search_globs) do
		vim.list_extend(command, { "--glob", glob })
	end
	MiniPick.builtin.cli({ command = command }, { source = { name = "Files" } })
end, "Find files")
map("fb", function()
	MiniPick.builtin.buffers()
end, "Find buffers")
map("fg", function()
	local config = vim.fn.executable("rg") == 1 and { tool = "rg", globs = vim.deepcopy(search_globs) } or {}
	MiniPick.builtin.grep_live(config)
end, "Search project")
map("fe", function()
	MiniExtra.pickers.diagnostic({ get_opts = { severity = vim.diagnostic.severity.ERROR } })
end, "Find errors in project")
map("gf", function()
	local root = vim.system({ "git", "rev-parse", "--show-toplevel" }, { text = true }):wait()
	if root.code ~= 0 then
		return vim.notify("Not inside a Git repository", vim.log.levels.WARN)
	end
	root = vim.trim(root.stdout)
	MiniPick.builtin.cli({
		command = { "git", "status", "--porcelain=v1", "-z", "--untracked-files=all" },
		postprocess = function(lines)
			local records = vim.split(table.concat(lines, "\n"), "\0", { plain = true, trimempty = true })
			local items, skip = {}, false
			for _, record in ipairs(records) do
				if skip then
					skip = false
				else
					table.insert(items, record:sub(4))
					skip = record:sub(1, 2):find("[RC]") ~= nil
				end
			end
			return items
		end,
	}, { source = { name = "Git status", cwd = root } })
end, "Find changed Git files")

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

if not vim.g.vscode then
	local clue = require("mini.clue")
	clue.setup({
		triggers = {
			{ mode = { "n", "x" }, keys = "<Leader>" },
			{ mode = "n", keys = "f" },
			{ mode = "n", keys = "[" },
			{ mode = "n", keys = "]" },
			{ mode = { "n", "x" }, keys = "g" },
			{ mode = "i", keys = "<C-x>" },
			{ mode = "n", keys = "<C-w>" },
			{ mode = { "n", "x" }, keys = "z" },
		},
		clues = {
			clue.gen_clues.square_brackets(),
			clue.gen_clues.builtin_completion(),
			clue.gen_clues.g(),
			clue.gen_clues.windows(),
			clue.gen_clues.z(),
			{ mode = "n", keys = "<Leader>b", desc = "+Buffers" },
			{ mode = "n", keys = "<Leader>h", desc = "+Git hunks" },
			{ mode = "n", keys = "<Leader>s", desc = "+Splits" },
		},
		window = { delay = 500 },
	})
end
