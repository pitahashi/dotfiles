vim.diagnostic.config({
	virtual_text = { spacing = 2, prefix = "●" },
	float = {
		border = "rounded",
		header = "",
		prefix = "",
		focusable = true,
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "",
			[vim.diagnostic.severity.WARN] = "",
			[vim.diagnostic.severity.INFO] = "",
			[vim.diagnostic.severity.HINT] = "󰌵",
		},
	},
	underline = true,
	update_in_insert = false,
	severity_sort = true,
})

vim.lsp.config("lua_ls", {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = {
		".luarc.json",
		".luarc.jsonc",
		".git",
	},
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				checkThirdParty = false,
			},
			telemetry = {
				enable = false,
			},
		},
	},
})

vim.lsp.config("ts", {
	cmd = { "typescript-language-server", "--stdio" },
	init_options = {
		hostInfo = "neovim",
	},
	before_init = function(_, config)
		-- Prefer workspace TypeScript; resolve mise's fallback without a fixed version path.
		local result = vim.system({ "mise", "where", "npm:typescript" }, { text = true }):wait()
		if result.code ~= 0 then
			return
		end
		for _, relative in ipairs({
			"node_modules/typescript/lib/tsserver.js",
			"lib/node_modules/typescript/lib/tsserver.js",
		}) do
			local path = vim.fs.joinpath(vim.trim(result.stdout), relative)
			if vim.fn.filereadable(path) == 1 then
				config.init_options.tsserver = { fallbackPath = path }
				break
			end
		end
	end,
	filetypes = {
		"javascript",
		"typescript",
		"javascriptreact",
		"typescriptreact",
	},
	root_markers = {
		"pnpm-lock.yaml",
		"yarn.lock",
		"bun.lock",
		"package-lock.json",
		".git",
	},
})

vim.lsp.config("gopls", {
	cmd = { "gopls" },
	filetypes = { "go", "gomod", "gowork", "gotmpl" },
	root_markers = {
		"go.work",
		"go.mod",
		".git",
	},
})

vim.lsp.config("intelephense", {
	cmd = { "intelephense", "--stdio" },
	filetypes = { "php" },
	root_markers = {
		"composer.json",
		".git",
	},
})

vim.lsp.enable({
	"lua_ls",
	"ts",
	"gopls",
	"intelephense",
})
