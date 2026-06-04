local opts = { noremap = true, silent = true }
vim.keymap.set("i", "jj", "<esc>")
vim.keymap.set("n", "<esc><esc>", ":nohl<CR>")
vim.keymap.set("n", "<C-u>", "15k", opts)
vim.keymap.set("n", "<C-d>", "15j", opts)
vim.keymap.set("n", "<leader>sv", "<C-w>v")
vim.keymap.set("n", "<leader>sh", "<C-w>s")
