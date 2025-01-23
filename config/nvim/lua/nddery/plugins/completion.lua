return {
	"b0o/schemastore.nvim",

	-- Collection of configurations for built-in LSP client
	{
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

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
				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
				vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
				vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
				-- vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
			end

			local servers = { "eslint", "ts_ls", "jsonls", "rust_analyzer", "lua_ls", "bashls", "tailwindcss" }

			for _, lsp in ipairs(servers) do
				lspconfig[lsp].setup({
					on_attach = on_attach,
					capabilities = capabilities,
					settings = {
						eslint = {
							format = false,
						},
						ts_ls = {
							format = { enable = false },
							init_options = {
								preferences = {
									importModuleSpecifier = "relative",
									importModuleSpecifierPreference = "relative",
								},
								importModuleSpecifierPreference = "relative",
							},
						},
						json = {
							schemas = require("schemastore").json.schemas(),
							validate = { enable = true },
						},
						Lua = {
							runtime = {
								version = "LuaJIT",
							},
							diagnostics = {
								globals = { "vim" },
							},
							workspace = {
								library = vim.api.nvim_get_runtime_file("", true),
							},
							telemetry = {
								enable = false,
							},
						},
						["rust-analyzer"] = {
							diagnostics = {
								enable = false,
							},
						},
					},
				})
			end
		end,
	},
	-- {
	-- 	"pmizio/typescript-tools.nvim",
	-- 	dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
	-- 	opts = {},
	-- },

	{ "nvim-lua/plenary.nvim", lazy = true },
	{ "nvimtools/none-ls-extras.nvim", lazy = true },
	{
		"nvimtools/none-ls.nvim",
		version = false,
		config = function()
			local null_ls = require("null-ls")

			null_ls.setup({
				sources = {
					require("none-ls.code_actions.eslint_d"),
				},
			})
		end,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvimtools/none-ls-extras.nvim",
		},
	},

	-- {
	-- 	"neovim/nvim-lspconfig",
	-- 	config = function()
	-- 		local lspconfig = require("lspconfig")
	--
	-- 		local opts = { noremap = true, silent = true }
	-- 		vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
	-- 		vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
	--
	-- 		-- Use an on_attach function to only map the following keys
	-- 		-- after the language server attaches to the current buffer
	-- 		local on_attach = function(client, bufnr)
	-- 			-- Enable completion triggered by <c-x><c-o>
	-- 			vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
	--
	-- 			-- Mappings.
	-- 			-- See `:help vim.lsp.*` for documentation on any of the below functions
	-- 			local bufopts = { noremap = true, silent = true, buffer = bufnr }
	-- 			vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
	-- 			vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
	-- 			vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
	-- 			vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
	-- 			vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
	-- 			vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
	-- 			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
	-- 			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
	-- 			-- vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
	-- 		end
	--    end
	-- },
	-- {
	-- 	"williamboman/mason-lspconfig.nvim",
	-- 	dependencies = { "williamboman/mason.nvim" },
	-- 	config = function()
	--      local lspconfig = require("lspconfig")
	--      local capabilities = require("cmp_nvim_lsp").default_capabilities()
	--
	-- 		require("mason-lspconfig").setup({
	-- 			ensure_installed = { "tsserver", "jsonls", "eslint", "rust_analyzer", "lua_ls", "bashls", "cssls" },
	--        handlers = {
	--          function(server_name)
	--            lspconfig[server_name].setup({
	--              capabilities = capabilities,
	--            })
	--          end,
	--          ["tsserver"] = function()
	--            lspconfig.tsserver.setup({
	--              capabilities = capabilities,
	--              settings = {
	--                tsserver = {
	--                  format = { enabled = false },
	--                }
	--              }
	--            })
	--          end,
	--          ["jsonls"] = function()
	--            lspconfig.json.setup {
	--              capabilities = capabilities,
	--              settings = {
	--                json = {
	--                  schemas = require("schemastore").json.schemas(),
	--                  validate = true,
	--                }
	--              }
	--            }
	--          end,
	--          ["lua_ls"] = function()
	--            lspconfig.lua_ls.setup {
	--              capabilities = capabilities,
	--              settings = {
	--                Lua = {
	--                  runtime = {
	--                    version = "LuaJIT",
	--                  },
	--                  diagnostics = {
	--                    globals = { "vim" },
	--                  },
	--                  workspace = {
	--                    library = vim.api.nvim_get_runtime_file("", true),
	--                  },
	--                  telemetry = {
	--                    enable = false,
	--                  }
	--                }
	--              }
	--            }
	--          end,
	--        }
	-- 		})
	-- 	end,
	-- },
}
