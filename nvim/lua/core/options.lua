-- options.lua
local opt = vim.opt

-- General settings
opt.autoindent = true
opt.hidden = true
opt.number = true
opt.incsearch = true
opt.ruler = true
opt.wildmenu = true
opt.relativenumber = true

-- Tab settings
opt.shiftwidth = 2
opt.smarttab = true
opt.expandtab = true
opt.tabstop = 8
opt.softtabstop = 0

-- Cursor settings
opt.guicursor = "n-v-c:block-Cursor/lCursor,i:ver25-CursorInsert/lCursorInsert,r-cr:hor20-CursorReplace/lCursorReplace"

-- Status line and appearance
opt.laststatus = 2
opt.termguicolors = true

-- Syntax and filetype
opt.syntax = 'on'
opt.filetype = 'plugin'

-- Regex engine
opt.regexpengine = 0
