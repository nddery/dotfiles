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
    notify = false
  }
})

require('nddery/options')
require('nddery/keymaps')
require('nddery/backups')

-- Source ~/.vimrc  content while I migrate to lua.
vim.cmd([[
  source ~/.vimrc
]])
