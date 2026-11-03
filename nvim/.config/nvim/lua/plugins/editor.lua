return {
  -- Seamless <C-h/j/k/l> between nvim splits and tmux panes, <M-h/j/k/l> to resize
  -- both. It sets the tmux pane option @pane-is-vim that tmux.conf checks.
  {
    "smart-splits-nvim/smart-splits.nvim",
    lazy = false, -- must load at startup to set @pane-is-vim
    dependencies = {
      { "smart-splits-nvim/backend-tmux", main = "smart-splits-backend-tmux", opts = {} },
    },
    opts = {
      mux = { backend = "smart-splits-backend-tmux" },
      move = { at_edge = "stop" }, -- keep in step with tmux.conf bindings
    },
    keys = {
      { "<C-h>", function() require("smart-splits").move_cursor_left() end, desc = "Go to left split/pane" },
      { "<C-j>", function() require("smart-splits").move_cursor_down() end, desc = "Go to lower split/pane" },
      { "<C-k>", function() require("smart-splits").move_cursor_up() end, desc = "Go to upper split/pane" },
      { "<C-l>", function() require("smart-splits").move_cursor_right() end, desc = "Go to right split/pane" },
      { "<M-h>", function() require("smart-splits").resize_left() end, desc = "Resize left" },
      { "<M-j>", function() require("smart-splits").resize_down() end, desc = "Resize down" },
      { "<M-k>", function() require("smart-splits").resize_up() end, desc = "Resize up" },
      { "<M-l>", function() require("smart-splits").resize_right() end, desc = "Resize right" },
      { "<leader><C-h>", function() require("smart-splits").swap_buf_left() end, desc = "Swap buffer left" },
      { "<leader><C-j>", function() require("smart-splits").swap_buf_down() end, desc = "Swap buffer down" },
      { "<leader><C-k>", function() require("smart-splits").swap_buf_up() end, desc = "Swap buffer up" },
      { "<leader><C-l>", function() require("smart-splits").swap_buf_right() end, desc = "Swap buffer right" },
    },
  },

  -- Run shell commands in a tmux pane (opens a split below if needed)
  {
    "preservim/vimux",
    cmd = { "VimuxRunCommand", "VimuxPromptCommand", "VimuxRunLastCommand" },
    init = function()
      vim.g.VimuxHeight = "30%"
      vim.g.VimuxOrientation = "v"
      vim.g.VimuxUseNearest = 1 -- reuse an existing pane in the window
    end,
    keys = {
      { "<leader>rp", "<cmd>VimuxPromptCommand<CR>", desc = "Run command in pane" },
      { "<leader>rl", "<cmd>VimuxRunLastCommand<CR>", desc = "Rerun last command" },
      { "<leader>ri", "<cmd>VimuxInspectRunner<CR>", desc = "Inspect runner pane" },
      { "<leader>rz", "<cmd>VimuxZoomRunner<CR>", desc = "Zoom runner pane" },
      { "<leader>rc", "<cmd>VimuxInterruptRunner<CR>", desc = "Interrupt (C-c) runner" },
      { "<leader>rq", "<cmd>VimuxCloseRunner<CR>", desc = "Close runner pane" },
      {
        "<leader>rt",
        function()
          local cmds = {
            go = "go test ./...",
            rust = "cargo test",
            c = "make test",
            cpp = "make test",
          }
          local cmd = cmds[vim.bo.filetype] or "make test"
          vim.cmd.write()
          vim.fn.VimuxRunCommand(cmd)
        end,
        desc = "Run project tests",
      },
      {
        "<leader>rb",
        function()
          local cmds = { go = "go build ./...", rust = "cargo build" }
          vim.cmd.write()
          vim.fn.VimuxRunCommand(cmds[vim.bo.filetype] or "make")
        end,
        desc = "Build project",
      },
      {
        "<leader>rs",
        function()
          local mode = vim.fn.mode()
          local text
          if mode == "v" or mode == "V" or mode == "\22" then
            text = table.concat(vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), { type = mode }), "\n")
            vim.api.nvim_feedkeys(vim.keycode("<Esc>"), "n", false)
          else
            text = vim.api.nvim_get_current_line()
          end
          vim.fn.VimuxRunCommand(text)
        end,
        mode = { "n", "x" },
        desc = "Send line/selection to pane",
      },
    },
  },

  -- File explorer as an editable buffer; "-" opens the parent directory
  {
    "stevearc/oil.nvim",
    lazy = false,
    keys = { { "-", "<cmd>Oil<CR>", desc = "Parent directory" } },
    opts = { view_options = { show_hidden = true } },
  },

  -- Git signs in the gutter + hunk actions
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      on_attach = function(buf)
        local gs = require("gitsigns")
        local map = function(l, r, desc) vim.keymap.set("n", l, r, { buffer = buf, desc = desc }) end
        map("]h", function() gs.nav_hunk("next") end, "Next hunk")
        map("[h", function() gs.nav_hunk("prev") end, "Prev hunk")
        map("<leader>gp", gs.preview_hunk, "Preview hunk")
        map("<leader>gr", gs.reset_hunk, "Reset hunk")
        map("<leader>gs", gs.stage_hunk, "Stage hunk")
        map("<leader>gb", gs.blame_line, "Blame line")
      end,
    },
  },

  -- Detect indentation per file
  { "NMAC427/guess-indent.nvim", event = "BufReadPre", opts = {} },

  -- Highlight TODO/FIXME/NOTE comments; <leader>st to search them
  {
    "folke/todo-comments.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false },
    keys = { { "<leader>st", "<cmd>TodoTelescope<CR>", desc = "Search TODOs" } },
  },

  -- Small quality-of-life modules
  { "nvim-mini/mini.pairs", event = "InsertEnter", opts = {} },
  { "nvim-mini/mini.surround", event = "VeryLazy", opts = {} },               -- sa / sd / sr
  { "nvim-mini/mini.ai", event = "VeryLazy", opts = { n_lines = 500 } },      -- better a/i textobjects
}
