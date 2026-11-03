return {
  {
    "nvim-telescope/telescope.nvim",
    event = "VimEnter",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-telescope/telescope-ui-select.nvim",
    },
    config = function()
      local telescope = require("telescope")
      local themes = require("telescope.themes")
      telescope.setup({
        defaults = {
          file_ignore_patterns = { "%.git/" },
        },
        pickers = {
          find_files = { hidden = true },
        },
        extensions = {
          ["ui-select"] = { themes.get_dropdown() },
        },
      })
      pcall(telescope.load_extension, "fzf")
      pcall(telescope.load_extension, "ui-select")

      local b = require("telescope.builtin")
      local map = function(l, r, desc) vim.keymap.set("n", l, r, { desc = desc }) end
      map("<leader>sh", b.help_tags, "Search help")
      map("<leader>sk", b.keymaps, "Search keymaps")
      map("<leader>sf", b.find_files, "Search files")
      map("<leader>ss", b.builtin, "Search telescope pickers")
      map("<leader>sw", b.grep_string, "Search current word")
      map("<leader>sg", b.live_grep, "Search by grep")
      map("<leader>sd", b.diagnostics, "Search diagnostics")
      map("<leader>sr", b.resume, "Search resume")
      map("<leader>s.", b.oldfiles, "Search recent files")
      map("<leader>sc", b.commands, "Search commands")
      map("<leader><leader>", b.buffers, "Find buffers")
      map("<leader>/", function()
        b.current_buffer_fuzzy_find(themes.get_dropdown({ winblend = 10, previewer = false }))
      end, "Fuzzy search in buffer")
      map("<leader>s/", function()
        b.live_grep({ grep_open_files = true, prompt_title = "Live Grep in Open Files" })
      end, "Search in open files")
      map("<leader>sn", function() b.find_files({ cwd = vim.fn.stdpath("config") }) end, "Search nvim config")

      -- LSP pickers (override the built-in gr* defaults with telescope versions)
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("telescope-lsp-attach", { clear = true }),
        callback = function(ev)
          local m = function(l, r, desc) vim.keymap.set("n", l, r, { buffer = ev.buf, desc = desc }) end
          m("grr", b.lsp_references, "Goto references")
          m("gri", b.lsp_implementations, "Goto implementation")
          m("grd", b.lsp_definitions, "Goto definition")
          m("grt", b.lsp_type_definitions, "Goto type definition")
          m("gO", b.lsp_document_symbols, "Document symbols")
          m("gW", b.lsp_dynamic_workspace_symbols, "Workspace symbols")
        end,
      })
    end,
  },
}
