-- Toggled by change_color_scheme (light ↔ dark). The colorscheme is chosen to
-- match the VS Code themes: github_light for light, night-owl for dark.
vim.opt.background = "dark"

return {
	{
		"projekt0n/github-nvim-theme",
		name = "github-theme",
		lazy = false,
		priority = 1000,
		config = function()
			require("github-theme").setup({})
		end,
	},
	{
		"oxfist/night-owl.nvim",
		lazy = false, -- load during startup: this is a main colorscheme
		priority = 1000, -- before other start plugins
		dependencies = { "projekt0n/github-nvim-theme" }, -- ensure both are available
		config = function()
			require("night-owl").setup({})
			if vim.o.background == "light" then
				vim.cmd.colorscheme("github_light")
			else
				vim.cmd.colorscheme("night-owl")
			end
		end,
	},
	"overcache/NeoSolarized",
}
