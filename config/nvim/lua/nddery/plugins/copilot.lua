return {
	"github/copilot.vim",
	-- https://github.com/orgs/community/discussions/139368
	tag = "v1.33.0",
	init = function()
		vim.g.copilot_no_tab_map = true
	 end,
  config = function()
		-- why this one does not work but tab does ????
		vim.api.nvim_set_keymap("i", "<S-CR>", 'copilot#Accept("\\<CR>")', { noremap = true, silent = true, expr = true })

    vim.api.nvim_set_keymap('i', '<C-[>', '<Plug>(copilot-previous)', {})
    vim.api.nvim_set_keymap('i', '<C-]>', '<Plug>(copilot-next)', {})

		vim.api.nvim_set_keymap(
			"i",
			"<S-Tab>",
			'copilot#Accept("<CR>")',
			{ noremap = true, silent = true, expr = true }
		)
	end,
}
