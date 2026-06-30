return {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	event = "InsertEnter",
	config = function()
		-- Volta's `node` shim resolves per-project, and some projects pin a Node
		-- older than Copilot's requirement (>= 22.13), which kills the server.
		-- Point Copilot at an absolute, modern Node image to bypass the shim.
		local node = vim.fn.expand("~/.volta/tools/image/node/24.14.1/bin/node")
		if vim.fn.executable(node) == 0 then
			node = "node"
		end

		require("copilot").setup({
			copilot_node_command = node,
			panel = { enabled = false },
			suggestion = {
				enabled = true,
				auto_trigger = true,
				keymap = {
					accept = "<C-J>",
					next = "<C-]>",
					prev = "<C-[>",
					dismiss = "<C-\\>",
				},
			},
		})
	end,
}
