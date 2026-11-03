-- LSP, completion and formatting for Go / Rust / C (+ Lua for this config)
local servers = {
  gopls = {
    settings = {
      gopls = {
        gofumpt = true,
        staticcheck = true,
        hints = { parameterNames = true, assignVariableTypes = true },
      },
    },
  },
  rust_analyzer = {
    settings = {
      ["rust-analyzer"] = { check = { command = "clippy" } },
    },
  },
  clangd = {
    cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=iwyu" },
  },
  lua_ls = {
    settings = {
      Lua = {
        runtime = { version = "LuaJIT" },
        workspace = { checkThirdParty = false, library = { vim.env.VIMRUNTIME } },
      },
    },
  },
}

-- Extra non-LSP tools for mason to install
local tools = {
  "stylua",          -- lua formatter
  "tree-sitter-cli", -- needed by nvim-treesitter (main) to build parsers
}

-- Some mason packages are built with system toolchains; only request them when
-- that toolchain exists, so startup doesn't spam install errors.
local has = function(bin) return vim.fn.executable(bin) == 1 end
local has_go = has("go")
if has_go then table.insert(tools, "goimports") end
-- clang-format is pip-installed by mason into a venv (needs python3-venv)
if has("python3") then table.insert(tools, "clang-format") end

return {
  {
    "mason-org/mason.nvim",
    lazy = false, -- puts mason's bin dir on PATH early
    opts = {},
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "saghen/blink.cmp",
    },
    config = function()
      -- Mason package names differ from lspconfig names
      local mason_names = {
        rust_analyzer = "rust-analyzer",
        clangd = "clangd",
        lua_ls = "lua-language-server",
      }
      if has_go then mason_names.gopls = "gopls" end
      local ensure = vim.list_extend(vim.tbl_values(mason_names), tools)
      require("mason-tool-installer").setup({ ensure_installed = ensure })

      vim.diagnostic.config({
        severity_sort = true,
        float = { source = "if_many" },
        underline = { severity = vim.diagnostic.severity.ERROR },
        virtual_text = { source = "if_many", spacing = 2 },
      })

      local capabilities = require("blink.cmp").get_lsp_capabilities()
      for name, cfg in pairs(servers) do
        cfg.capabilities = vim.tbl_deep_extend("force", {}, capabilities, cfg.capabilities or {})
        vim.lsp.config(name, cfg)
        vim.lsp.enable(name)
      end

      -- Built-in 0.11 defaults: K hover, grn rename, gra code action, grr refs, gri impl, gO symbols
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("user-lsp-attach", { clear = true }),
        callback = function(ev)
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          local map = function(l, r, desc) vim.keymap.set("n", l, r, { buffer = ev.buf, desc = desc }) end
          map("grD", vim.lsp.buf.declaration, "Goto declaration")
          if client and client:supports_method("textDocument/inlayHint", ev.buf) then
            map("<leader>ch", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf }))
            end, "Toggle inlay hints")
          end
          -- Highlight references of the word under the cursor
          if client and client:supports_method("textDocument/documentHighlight", ev.buf) then
            local hl = vim.api.nvim_create_augroup("user-lsp-highlight", { clear = false })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = ev.buf, group = hl, callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = ev.buf, group = hl, callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })
    end,
  },

  -- Completion
  {
    "saghen/blink.cmp",
    version = "1.*", -- prebuilt fuzzy-matcher binary
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = { { "L3MON4D3/LuaSnip", version = "2.*" } },
    opts = {
      keymap = { preset = "default" }, -- <C-y> accept, <C-n>/<C-p> select, <C-space> open
      appearance = { nerd_font_variant = "mono" },
      completion = { documentation = { auto_show = true, auto_show_delay_ms = 300 } },
      sources = { default = { "lsp", "path", "snippets", "buffer" } },
      snippets = { preset = "luasnip" },
      signature = { enabled = true },
    },
  },

  -- Formatting
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    keys = {
      {
        "<leader>cf",
        function() require("conform").format({ async = true, lsp_format = "fallback" }) end,
        mode = { "n", "v" },
        desc = "Format buffer",
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = { timeout_ms = 1000, lsp_format = "fallback" },
      formatters_by_ft = {
        lua = { "stylua" },
        go = { "goimports", "gofmt" },
        rust = { "rustfmt" }, -- comes with the rust toolchain (rustup)
        c = { "clang-format" },
        cpp = { "clang-format" },
      },
    },
  },
}
