-- nvim-treesitter (main branch): parsers are installed on demand, highlighting
-- and indent are started per buffer. Requires the tree-sitter CLI (installed by mason).
return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local ts = require("nvim-treesitter")
      ts.install({
        "bash", "c", "cpp", "diff", "go", "gomod", "gosum", "lua", "luadoc", "make",
        "markdown", "markdown_inline", "query", "rust", "toml", "vim", "vimdoc", "yaml",
      })

      local function attach(buf, lang)
        if not vim.treesitter.language.add(lang) then return end
        vim.treesitter.start(buf, lang)
        vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end

      local available = ts.get_available()
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("user-treesitter", { clear = true }),
        callback = function(args)
          local lang = vim.treesitter.language.get_lang(args.match)
          if not lang then return end
          if vim.tbl_contains(ts.get_installed("parsers"), lang) then
            attach(args.buf, lang)
          elseif vim.tbl_contains(available, lang) then
            ts.install(lang):await(function() attach(args.buf, lang) end)
          else
            attach(args.buf, lang)
          end
        end,
      })
    end,
  },
}
