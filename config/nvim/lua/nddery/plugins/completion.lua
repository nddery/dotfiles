vim.cmd([[
  imap <silent><script><expr> <S-CR> copilot#Accept("\<CR>")
  let g:copilot_no_tab_map = v:true
]])

return {
	-- -- + stuff from vimrc
	-- { 'neoclide/coc.nvim', branch = 'release' },
	"github/copilot.vim",

	-- -- LSP
	-- use { "neovim/nvim-lspconfig", commit = "f11fdff7e8b5b415e5ef1837bdcdd37ea6764dda" } -- enable LSP
	--  use { "williamboman/mason.nvim", commit = "c2002d7a6b5a72ba02388548cfaf420b864fbc12"} -- simple to use language server installer
	--  use { "williamboman/mason-lspconfig.nvim", commit = "0051870dd728f4988110a1b2d47f4a4510213e31" }
	-- use { "jose-elias-alvarez/null-ls.nvim", commit = "c0c19f32b614b3921e17886c541c13a72748d450" } -- for formatters and linters
	--  use { "RRethy/vim-illuminate", commit = "a2e8476af3f3e993bb0d6477438aad3096512e42" }

	{ -- Collection of configurations for built-in LSP client
		"neovim/nvim-lspconfig",
		config = function()
			-- local null_ls = require('null-ls')
			-- local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
			-- null_ls.setup({
			--   null_ls.builtins.formatting.stylua,
			--   null_ls.builtins.diagnostics.eslint,
			--   null_ls.builtins.completion.spell,
			-- })

			local lspconfig = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			--
			-- !!! adding mappings that starts with <space> leads to a 300ms delay before opening command mode
			--
			local opts = { noremap = true, silent = true }
			-- vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
			vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
			vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
			-- vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

			-- Use an on_attach function to only map the following keys
			-- after the language server attaches to the current buffer
			local on_attach = function(client, bufnr)
				-- Enable completion triggered by <c-x><c-o>
				vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

				-- Mappings.
				-- See `:help vim.lsp.*` for documentation on any of the below functions
				local bufopts = { noremap = true, silent = true, buffer = bufnr }
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
				vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
				vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
				-- vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
				-- vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
				-- vim.keymap.set('n', '<space>wl', function()
				--   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
				-- end, bufopts)
				-- vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
				-- vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
				-- vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
				vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
				vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
				-- vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)

				-- if client.supports_method('textDocument/formatting') then
				--   vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
				--   vim.api.nvim_create_autocmd('BufWritePre', {
				--     group = augroup,
				--     buffer = bufnr,
				--     callback = function()
				--       -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
				--       vim.lsp.buf.formatting_sync()
				--     end,
				--   })
				-- end
			end

			-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
			local servers = { "rust_analyzer", "tsserver" }
			for _, lsp in ipairs(servers) do
				lspconfig[lsp].setup({
					on_attach = on_attach,
					-- Add additional capabilities supported by nvim-cmp
					capabilities = capabilities,
				})
			end
		end,
	},
	{ -- Autocompletion plugin
		"hrsh7th/nvim-cmp",
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-u>"] = cmp.mapping.scroll_docs(-4), -- Up
					["<C-d>"] = cmp.mapping.scroll_docs(4), -- Down
					-- C-b (back) C-f (forward) for snippet placeholder navigation.
					["<C-Space>"] = cmp.mapping.complete(),
					["<CR>"] = cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Replace,
						select = true,
					}),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = {
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
				},
			})
		end,
	},

	{ -- for formatters and linters
		"jose-elias-alvarez/null-ls.nvim",
		version = false,
		-- setup = function()
		--   local null_ls = require('null-ls')
		--
		--   null_ls.setup({
		--     sources = {
		--       null_ls.builtins.completion.spell,
		--       null_ls.builtins.diagnostics.eslint,
		--       null_ls.builtins.formatting.prettier,
		--       null_ls.builtins.formatting.stylua,
		--     }
		--   })
		-- end
		dependenies = {
			{ "nvim-lua/plenary.nvim" },
		},
	},

	"hrsh7th/cmp-buffer", -- buffer completions
	"hrsh7th/cmp-path", -- path completions
	"hrsh7th/cmp-nvim-lsp", -- LSP source for nvim-cmp
	"hrsh7th/cmp-nvim-lua", -- Lua source for nvim-cmp
	"saadparwaiz1/cmp_luasnip", -- Snippets source for nvim-cmp
	"L3MON4D3/LuaSnip", -- Snippets plugin
}
