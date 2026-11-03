return {
  -- Seamless <C-h/j/k/l> between nvim splits and tmux panes (tmux side in tmux.conf)
  {
    "christoomey/vim-tmux-navigator",
    cmd = { "TmuxNavigateLeft", "TmuxNavigateDown", "TmuxNavigateUp", "TmuxNavigateRight" },
    keys = {
      { "<C-h>", "<cmd>TmuxNavigateLeft<CR>" },
      { "<C-j>", "<cmd>TmuxNavigateDown<CR>" },
      { "<C-k>", "<cmd>TmuxNavigateUp<CR>" },
      { "<C-l>", "<cmd>TmuxNavigateRight<CR>" },
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
