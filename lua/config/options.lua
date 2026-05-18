vim.g.mapleader = " "
vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.updatetime = 50

vim.opt.spelllang = "en_us"
vim.opt.spell = true

vim.g.mkdp_browser = ""

vim.opt.scrolloff = 999
vim.opt.sidescrolloff = 8

vim.opt.backup = false -- Don't create backup files
vim.opt.writebackup = false -- Don't create backup before writing
vim.opt.swapfile = false -- Don't create swap files
vim.opt.undofile = true -- Persistent undo

vim.opt.ignorecase = true -- Case insensitive search
vim.opt.smartcase = true -- Case sensitive if uppercase in search
vim.opt.hlsearch = false -- Don't highlight search results

vim.opt.synmaxcol = 300 -- Syntax highlighting limit
vim.opt.updatetime = 300 -- Faster completion
vim.opt.redrawtime = 10000
vim.opt.maxmempattern = 20000

-- New UI opt-in
require("vim._core.ui2").enable({})
