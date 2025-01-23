return {
	"github/copilot.vim",
	init = function()
		vim.g.copilot_no_tab_map = true
		vim.g.copilot_workspace_folders = { vim.fn.getcwd() }
	end,
	config = function()
		vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("\\<CR>")', {
			expr = true,
			replace_keycodes = false,
		})

		vim.api.nvim_set_keymap("i", "<C-[>", "<Plug>(copilot-previous)", {})
		vim.api.nvim_set_keymap("i", "<C-]>", "<Plug>(copilot-next)", {})
	end,
}
