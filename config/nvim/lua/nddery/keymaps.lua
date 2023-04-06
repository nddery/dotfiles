vim.keymap.set("n", "<space>", ":")
vim.keymap.set("i", "jj", "<esc>")

vim.keymap.set("n", "Y", "y$", { desc = "Yank to end of line", remap = false })
vim.keymap.set("i", "<C-d>", "<Del>", { desc = "Delete character under cursor" })

-- Wrapped lines goes down/up to next row, rather than next line in file.
vim.keymap.set("", "j", "gj", { remap = false })
vim.keymap.set("", "k", "gk", { remap = false })

-- Visual shifting (does not exit Visual mode)
vim.keymap.set("v", "<", "<gv", { remap = false })
vim.keymap.set("v", ">", ">gv", { remap = false })

vim.keymap.set("c", "w!!", "w !sudo tee % >/dev/null", { desc = "Write file as root" })

-- for init, max value, increment
for i = 0, 9, 1 do
	vim.keymap.set("n", "<leader>f" .. i, "<cmd>set foldlevel=" .. i .. "<cr>", { desc = "Set foldlevel to " .. i })
end
vim.keymap.set("n", "<leader>f-", "<cmd>set foldlevel=100<cr>", { desc = "Set foldlevel to 100" })
