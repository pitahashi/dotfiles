vim.api.nvim_create_user_command("CopyMessages", function()
	local messages = vim.fn.execute("messages")
	vim.fn.setreg("+", messages)
	print("Copied Messages to clipboard")
end, {
	desc = "Copy NVIM Messages to clipboard",
})

vim.api.nvim_create_user_command("CopyAll", function()
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	vim.fn.setreg("+", table.concat(lines, "\n"))
end, {
	desc = "Copy the entire buffer to clipboard",
})
