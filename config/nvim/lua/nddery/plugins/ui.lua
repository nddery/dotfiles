return {
	{
		"scrooloose/nerdtree",
		keys = {
			{ "<C-e>", "<cmd>NERDTreeToggle<cr>", desc = "NERDTree toggle" },
		},
		config = function()
			vim.cmd([[
	       let NERDTreeShowBookmarks=1
	       let NERDTreeIgnore=['\.py[cd]$', '\~$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$', '\.DS_Store$']
	       let NERDTreeChDirMode=0
	       let NERDTreeMouseMode=2
	       let NERDTreeShowHidden=1
	       let NERDTreeKeepTreeInNewTab=1
	       let NERDTreeWinSize=40
	       " let g:nerdtree_tabs_open_on_gui_startup=0
	     ]])
		end,
	},

	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		opts = function(plugin)
			local icons = require("nddery/config").icons

			local function fg(name)
				return function()
					---@type {foreground?:number}?
					local hl = vim.api.nvim_get_hl_by_name(name, true)
					return hl and hl.foreground and { fg = string.format("#%06x", hl.foreground) }
				end
			end

			return {
				options = {
					theme = "auto",
					globalstatus = true,
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
					disabled_filetypes = { statusline = { "dashboard", "lazy", "alpha" } },
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch" },
					lualine_c = {
						{
							"diagnostics",
							symbols = {
								error = icons.diagnostics.Error,
								warn = icons.diagnostics.Warn,
								info = icons.diagnostics.Info,
								hint = icons.diagnostics.Hint,
							},
						},
						{ "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
						{ "filename", path = 1, symbols = { modified = "  ", readonly = "", unnamed = "" } },
						{
							function()
								return require("nvim-navic").get_location()
							end,
							cond = function()
								return package.loaded["nvim-navic"] and require("nvim-navic").is_available()
							end,
						},
					},
					lualine_x = {
						{
							function()
								return require("noice").api.status.command.get()
							end,
							cond = function()
								return package.loaded["noice"] and require("noice").api.status.command.has()
							end,
							color = fg("Statement"),
						},
						{
							function()
								return require("noice").api.status.mode.get()
							end,
							cond = function()
								return package.loaded["noice"] and require("noice").api.status.mode.has()
							end,
							color = fg("Constant"),
						},
						{
							require("lazy.status").updates,
							cond = require("lazy.status").has_updates,
							color = fg("Special"),
						},
						{
							"diff",
							symbols = {
								added = icons.git.added,
								modified = icons.git.modified,
								removed = icons.git.removed,
							},
						},
					},
					lualine_y = {
						{ "progress", separator = " ", padding = { left = 1, right = 0 } },
						{ "location", padding = { left = 0, right = 1 } },
					},
				},
				extensions = { "neo-tree" },
			}
		end,
	},

	-- display context in statusline
	{
		"utilyre/barbecue.nvim",
		dependencies = {
			"SmiteshP/nvim-navic",
		},
		opts = {
			-- configurations go here
		},
	},

	{
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
				untracked = { text = "┆" },
			},
		},
	},

	-- icons
	{ "nvim-tree/nvim-web-devicons", lazy = true },
}
