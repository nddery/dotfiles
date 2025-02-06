return {
	"CopilotC-Nvim/CopilotChat.nvim",
	dependencies = {
		{ "github/copilot.vim" },
		{ "nvim-lua/plenary.nvim", branch = "master" },
	},
	build = "make tiktoken",
	opts = {
		model = "claude-3.5-sonnet",
	},
	keys = {
		{
			"<leader>o",
			function()
				require("CopilotChat").open()
			end,
			desc = "CopilotChat",
		},
		{
			"<leader>q",
			function()
				local input = vim.fn.input("Quick Chat: ")
				if input ~= "" then
					require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
				end
			end,
			desc = "CopilotChat - Quick chat",
		},
		{
			"<leader>cp",
			function()
				local actions = require("CopilotChat.actions")
				require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
			end,
			desc = "CopilotChat - Prompt actions",
		},
	},
	-- See Commands section for default commands if you want to lazy load on them
}
