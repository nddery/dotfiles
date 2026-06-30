vim.opt.backup = true
vim.opt.undofile = true
vim.opt.undolevels = 1000
vim.opt.undoreload = 10000

local home_directory = os.getenv("HOME")

local directories = {
	backup = "backupdir",
	views = "viewdir",
	swap = "directory",
	undo = "undodir",
}

for directory_suffix, setting_name in pairs(directories) do
	-- eg.: ~/.vimbackup/
	local directory = home_directory .. "/.vim" .. directory_suffix .. "/"

	vim.fn.mkdir(directory, "p")

	if vim.uv.fs_stat(directory) then
		vim.opt[setting_name] = directory
	else
		vim.notify("Unable to create backup directory: " .. directory, vim.log.levels.WARN)
	end
end
