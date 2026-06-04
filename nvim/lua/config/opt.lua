vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.wrap = true
vim.opt.confirm = true
vim.opt.termguicolors = true
vim.opt.updatetime = 250
vim.opt.winborder = "rounded"

vim.opt.laststatus = 3
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.cursorline = true
vim.opt.signcolumn = "yes:1"
vim.opt.scrolloff = 8
vim.opt.showcmd = true
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.backup = false
vim.opt.clipboard = "unnamedplus"

vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.showmode = true
require("vim._core.ui2").enable({})
