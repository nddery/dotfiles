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
	local directory_name = ".vim" .. directory_suffix
	local directory = home_directory .. "/" .. directory_name .. "/"

	if not vim.loop.fs_stat(directory) then
		os.execute("mkdir " .. directory)
	end

	if vim.loop.fs_stat(directory) then
		vim.opt[setting_name] = directory
	else
		print("Warning: Unable to create backup directory: " .. directory)
	end
end
