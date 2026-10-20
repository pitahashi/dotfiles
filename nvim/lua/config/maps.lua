local keymap_opts = { noremap = true, silent = true }
vim.keymap.set("n", "<leader>cm", "<cmd>CopyMessages<cr>", { desc = "Copy messages" })
vim.keymap.set("i", "jj", "<esc>")
vim.keymap.set("n", "<esc><esc>", ":nohl<CR>")
vim.keymap.set("n", "<C-u>", "15k", keymap_opts)
vim.keymap.set("n", "<C-d>", "15j", keymap_opts)
vim.keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split vertically" })
vim.keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split horizontally" })
