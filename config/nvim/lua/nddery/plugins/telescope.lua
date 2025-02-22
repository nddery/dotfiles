return {
	"nvim-telescope/telescope.nvim",
	cmd = "Telescope",
	version = false,
	keys = {
		{ "<c-f>", "<cmd>Telescope find_files<cr>", desc = "Find file" },
		{ "<c-g>", "<cmd>Telescope git_files<cr>", desc = "Find files (git)" },
		{ "<c-b>", "<cmd>Telescope buffers<cr>", desc = "Find buffer" },
		-- { "<leader>,", "<cmd>Telescope buffers<cr>", desc = "Find buffer" },
		{ "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Find recent" },
		{ "<c-s>", "<cmd>Telescope live_grep<cr>", desc = "Search" },
		{ "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer" },
		{
			"<leader>f",
			function()
				require("telescope.builtin").live_grep({ default_text = vim.fn.expand("<cword>") })
			end,
			desc = "Search word under cursor",
		},
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")

		telescope.setup({
			defaults = {
				-- path_display = { "smart" },
				path_display = { "truncate" },
				mappings = {
					n = {
						["<c-d>"] = actions.delete_buffer,
					},
					i = {
						["<C-h>"] = "which_key",
						["<c-d>"] = actions.delete_buffer,
						["<c-f>"] = actions.send_selected_to_qflist,
					},
				},
			},
		})

		telescope.load_extension("fzf")
	end,
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
}
