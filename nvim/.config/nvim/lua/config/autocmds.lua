local au = vim.api.nvim_create_autocmd
local group = vim.api.nvim_create_augroup("user", { clear = true })

-- Briefly highlight yanked text
au("TextYankPost", {
  group = group,
  callback = function() vim.hl.on_yank() end,
})

-- Restore cursor position when reopening a file
au("BufReadPost", {
  group = group,
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(args.buf) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Reload files changed outside nvim (git checkout, formatters, other tmux panes).
-- tmux forwards focus events (focus-events on), so FocusGained fires on pane switch.
vim.o.autoread = true
au({ "FocusGained", "BufEnter", "TermClose", "TermLeave" }, {
  group = group,
  callback = function()
    if vim.o.buftype ~= "nofile" and vim.fn.getcmdwintype() == "" then
      vim.cmd.checktime()
    end
  end,
})
au("FileChangedShellPost", {
  group = group,
  callback = function(args)
    vim.notify("Reloaded " .. vim.fn.fnamemodify(args.file, ":~:."), vim.log.levels.INFO)
  end,
})

-- Go uses tabs
au("FileType", {
  group = group,
  pattern = "go",
  callback = function() vim.opt_local.expandtab = false end,
})
