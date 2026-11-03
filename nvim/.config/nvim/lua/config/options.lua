local o = vim.opt

-- UI
o.number = true
o.relativenumber = true
o.signcolumn = "yes"        -- no jumping when diagnostics/git signs appear
o.cursorline = true
o.termguicolors = true
o.scrolloff = 8
o.sidescrolloff = 8
o.wrap = false
o.showmode = false          -- mode is shown in the statusline
o.splitright = true
o.splitbelow = true
o.list = true
o.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
o.winborder = "rounded"     -- borders for floating windows (hover, diagnostics)

-- Editing
o.expandtab = true
o.shiftwidth = 4
o.tabstop = 4
o.smartindent = true
o.undofile = true           -- persistent undo
o.mouse = "a"
o.clipboard = "unnamedplus" -- system clipboard (OSC 52 works through tmux)
o.confirm = true

-- Search
o.ignorecase = true
o.smartcase = true
o.inccommand = "split"      -- live preview of :s

-- Timing
o.updatetime = 250
o.timeoutlen = 400
