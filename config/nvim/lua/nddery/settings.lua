vim.g.mapleader = ","

vim.opt.termguicolors = true
vim.opt.timeoutlen = 300
vim.opt.mouse = "a"
vim.opt.wrap = false -- do not wrap lines
vim.opt.linebreak = true -- don't split words when wrapping
vim.opt.relativenumber = true
vim.opt.colorcolumn = "80"
vim.opt.shortmess = vim.opt.shortmess + "filmnrxoOtT" -- abbreviation of messages (avoids 'hit enter')
vim.opt.virtualedit = "onemore" -- allow cursor beyond last character
vim.opt.spell = true
vim.opt.autoread = true -- auto read files when they change
vim.opt.hidden = true -- allow buffer switching without saving
vim.opt.iskeyword = vim.opt.iskeyword - { ".", "#", "-" } -- '.' '#' '-' are end of word designator
vim.opt.clipboard = "unnamed"
vim.opt.viewoptions = "cursor,folds,slash,unix"

vim.opt.shiftwidth = 2 -- use indents of 2 spaces
vim.opt.expandtab = true -- tabs are spaces, not tabs
vim.opt.tabstop = 2 -- an indentation every two columns
vim.opt.softtabstop = 2 -- let backspace delete indent
vim.opt.splitright = true -- puts new vsplit windows to the right of the current
vim.opt.splitbelow = true -- puts new split windows to the bottom of the current
-- vim.opt.pastetoggle = "<F12>" -- pastetoggle (sane indentation on pastes)

vim.opt.showmode = true -- display the current mode
vim.opt.cursorline = true -- highlight current line
vim.opt.signcolumn = "yes" -- show signs in the signcolumn

-- if has('cmdline_info')
-- vim.cmd([[set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%)]])
-- vim.opt.rulerformat = '%30(%=:b%n%y%m%r%w %l,%c%V %P%)' -- a ruler on steroids
vim.opt.showcmd = true -- show partial commands in status line and selected characters/lines in visual mode
-- endif

vim.opt.linespace = 0 -- no extra spaces between rows
vim.opt.number = true -- line numbers on
vim.opt.showmatch = true -- show matching brackets/parenthesis
vim.opt.hlsearch = true -- highlight search terms
vim.opt.winminheight = 0 -- windows can be 0 line high
vim.opt.ignorecase = true -- case insensitive search
vim.opt.smartcase = true -- case sensitive when uc present
vim.opt.wildmode = { "list:longest", "full" } -- command <tab> completion, list matches, then longest common part, then all.
vim.opt.whichwrap = "b,s,h,l,<,>,[" -- backspace and cursor keys wrap too
vim.opt.scrolloff = 10 -- lines before cursor is considered to have left screen
vim.opt.scrolljump = 1 -- lines to scroll when cursor leaves screen

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = true
vim.opt.foldlevelstart = 100

-- disables netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.jsx_ext_required = 0
vim.g.vim_json_syntax_conceal = 0
vim.g.vim_markdown_conceal = 0
vim.g.vim_markdown_conceal_code_blocks = 0
