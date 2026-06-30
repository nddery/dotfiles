return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false, -- the main branch does not support lazy-loading
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter").setup()

			-- Install parsers (async; a no-op for already-installed ones).
			require("nvim-treesitter").install({
				"astro",
				"bash",
				"c",
				"vimdoc",
				"html",
				"javascript",
				"json",
				"lua",
				"luap",
				"markdown",
				"markdown_inline",
				"python",
				"query",
				"regex",
				"tsx",
				"typescript",
				"vim",
				"yaml",
			})

			-- The main branch no longer enables features through setup(); highlight
			-- and indentation are wired up per buffer via Neovim's own treesitter.
			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("nddery-treesitter", { clear = true }),
				callback = function(args)
					-- start() errors when no parser is installed for this filetype.
					if not pcall(vim.treesitter.start) then
						return
					end
					-- Indentation is experimental; keep it off for python to match
					-- the previous indent.disable config.
					if vim.bo[args.buf].filetype ~= "python" then
						vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					end
				end,
			})
		end,
	},

	{
		"windwp/nvim-ts-autotag",
		ft = {
			"html",
			"javascript",
			"javascriptreact",
			"typescript",
			"typescriptreact",
			"astro",
			"markdown",
			"svelte",
			"vue",
			"xml",
		},
		config = function()
			require("nvim-ts-autotag").setup()
		end,
	},
}
