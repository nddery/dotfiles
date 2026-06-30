return {
	{
		"williamboman/mason.nvim",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
		config = function()
			require("mason").setup({
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})

			-- Auto-enable every installed server against the native LSP client
			-- (vim.lsp.enable). No ensure_installed here: mason-tool-installer
			-- below is the single source of truth for what gets installed.
			require("mason-lspconfig").setup({
				ensure_installed = {},
				automatic_enable = true,
			})

			-- Installs AND keeps up to date. Names are Mason package names
			-- (see :Mason), which differ from lspconfig/vim.lsp names.
			require("mason-tool-installer").setup({
				ensure_installed = {
					-- LSP servers
					"lua-language-server",
					"typescript-language-server",
					"eslint-lsp",
					"json-lsp",
					"bash-language-server",
					"tailwindcss-language-server",
					"rust-analyzer",
					-- Formatters
					"prettier",
					"prettierd",
					"stylua",
				},
				run_on_start = true,
				auto_update = true,
			})
		end,
	},
}
