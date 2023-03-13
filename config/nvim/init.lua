-- Make sure to set `mapleader` before lazy so your mappings are correct
vim.g.mapleader = ","

-- Initialize lazy.nvim package manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup("nddery/plugins", {
	change_detection = {
		notify = false,
	},
})

require("nddery/options")
require("nddery/keymaps")
require("nddery/backups")

-- figure out why this can't be in the lazy.nvim setup function callback...
local null_ls = require("null-ls")

null_ls.setup({
	sources = {
		null_ls.builtins.code_actions.eslint,
		null_ls.builtins.completion.spell,
		null_ls.builtins.diagnostics.eslint,
		null_ls.builtins.formatting.prettier,
		null_ls.builtins.formatting.stylua,
	},
	on_attach = function(client, bufnr)
		local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format({
						bufnr = buff,
						filter = function(client)
							return client.name == "null-ls"
						end,
					})
				end,
			})
		end
	end,
})
