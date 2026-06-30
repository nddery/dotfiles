return {
	{
		"echasnovski/mini.nvim",
		version = false,
		config = function()
			require("mini.basics").setup({})
			require("mini.bracketed").setup({})
			require("mini.comment").setup({
				mappings = {
					comment = "<leader>c",
					comment_line = "<leader>c",
					comment_visual = "<leader>c",
				},
			})
			require("mini.cursorword").setup({})

			local misc = require("mini.misc")
			misc.setup_restore_cursor()

			require("mini.pairs").setup({})
			require("mini.trailspace").setup({})
		end,
	},

	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},

	"tpope/vim-fugitive",
	"tpope/vim-surround",

	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {
			indent = {
				char = "│",
			},
		},
	},

	{
		"alexghergh/nvim-tmux-navigation",
		version = false,
		lazy = false,
		config = function()
			require("nvim-tmux-navigation").setup({
				disable_when_zoomed = true,
				keybindings = {
					left = "<C-h>",
					down = "<C-j>",
					up = "<C-k>",
					right = "<C-l>",
					last_active = "<C-\\>",
					next = "<C-Space>",
				},
			})
		end,
	},
	"rhysd/conflict-marker.vim",
	"LunarVim/bigfile.nvim",

	{
		"folke/flash.nvim",
		event = "VeryLazy",
		opts = {},
		keys = {
			{
				"s",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump()
				end,
				desc = "Flash",
			},
			{
				"S",
				mode = { "n", "x", "o" },
				function()
					require("flash").treesitter()
				end,
				desc = "Flash Treesitter",
			},
		},
	},

	-- Language support (highlighting and indentation) {
	-- 'sheerun/vim-polyglot',
	{ "jasdel/vim-smithy", ft = "smithy" },
	{ "darfink/vim-plist", ft = "plist" },
	-- }

	-- PHP {
	{ "shawncplus/phpcomplete.vim", ft = "php" },
	{ "arnaud-lb/vim-php-namespace", ft = "php" },
	-- }

	-- Ruby {
	{ "tpope/vim-rails", ft = "ruby" },
	{ "tpope/vim-endwise", ft = "ruby" },
	-- }

	-- CSS {
	"hail2u/vim-css3-syntax",
	-- }
}
