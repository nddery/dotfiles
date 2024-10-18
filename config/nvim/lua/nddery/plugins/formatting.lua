return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				astro = { "prettier" },
				css = { "prettier" },
				html = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
				svelte = { "prettierd" },
				graphql = { "prettierd" },
				lua = { "stylua" },
				rust = { "rustfmt" },
				go = { "gofmt" },
				python = { "isort", "black" },
			},
			format_after_save = {
				lsp_format = "fallback",
			},
		})
	end,
}
