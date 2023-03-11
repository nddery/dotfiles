return {
  {
    'folke/tokyonight.nvim',
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      vim.opt.background = "dark"
      vim.cmd.colorscheme('tokyonight')
    end,
  },
  'overcache/NeoSolarized',
  -- 'altercation/vim-colors-solarized',
  -- 'flazz/vim-colorschemes',
}
