return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"saghen/blink.cmp",
			"b0o/schemastore.nvim",
		},
		config = function()
			-- Completion capabilities shared by every server.
			local capabilities = require("blink.cmp").get_lsp_capabilities()
			vim.lsp.config("*", {
				capabilities = capabilities,
			})

			-- Per-server overrides. Defaults (cmd, filetypes, root markers)
			-- come from nvim-lspconfig's bundled lsp/<name>.lua definitions.
			vim.lsp.config("lua_ls", {
				settings = {
					Lua = {
						runtime = { version = "LuaJIT" },
						diagnostics = { globals = { "vim" } },
						telemetry = { enable = false },
					},
				},
			})

			vim.lsp.config("jsonls", {
				settings = {
					json = {
						schemas = require("schemastore").json.schemas(),
						validate = { enable = true },
					},
				},
			})

			vim.lsp.config("ts_ls", {
				init_options = {
					preferences = {
						importModuleSpecifier = "relative",
						importModuleSpecifierPreference = "relative",
					},
				},
			})

			-- eslint LSP provides diagnostics + code-actions; conform owns
			-- formatting, so disable eslint's own formatter.
			vim.lsp.config("eslint", {
				settings = {
					format = false,
				},
			})

			vim.lsp.config("rust_analyzer", {
				settings = {
					["rust-analyzer"] = {
						diagnostics = { enable = false },
					},
				},
			})

			-- Diagnostics UI.
			vim.diagnostic.config({
				virtual_text = true,
				severity_sort = true,
			})

			-- Buffer-local keymaps, bound when any server attaches.
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("nddery-lsp-attach", { clear = true }),
				callback = function(event)
					local bufopts = { noremap = true, silent = true, buffer = event.buf }
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
					vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
					vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
					vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
				end,
			})

			-- Diagnostic navigation (global), replacing deprecated goto_prev/next.
			local opts = { noremap = true, silent = true }
			vim.keymap.set("n", "[d", function()
				vim.diagnostic.jump({ count = -1, float = true })
			end, opts)
			vim.keymap.set("n", "]d", function()
				vim.diagnostic.jump({ count = 1, float = true })
			end, opts)
		end,
	},
}
