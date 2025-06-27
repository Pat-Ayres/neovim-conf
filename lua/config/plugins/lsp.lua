return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      'saghen/blink.cmp',
      {
        "folke/lazydev.nvim",
        opts = {
          library = {
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
    },
    config = function()
      local lspconfig = require("lspconfig")
      local util = require("lspconfig.util")
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      -- set a consistent offsetEncoding to ensure all clients match when multiple clients are loaded
      capabilities.offsetEncoding = { "utf-16" }

      -- function to force utf-16 encoding on clients during init
      local function force_utf16(client, init_result)
        client.offset_encoding = "utf-16"
        return init_result
      end

      -- language configurations
      lspconfig.lua_ls.setup { capabilites = capabilities }

      lspconfig.gopls.setup { capabilities = capabilities }

      lspconfig.rust_analyzer.setup { capabilities = capabilities }

      lspconfig.terraformls.setup({
        capabilities = capabilities,
        cmd = {
          "terraform-ls",
          "serve"
        },
        filetypes = {
          "terraform",
          "tf",
          "hcl",
        }
      })
      lspconfig.tflint.setup { capabilities = capabilities }

      -- location of a custom gemfile to run ruby-lsp with shared org overcommit gemfile
      local custom_gemfile = vim.fn.expand("~/src/scratch/overcommit-ruby-lsp/Gemfile")
      if vim.fn.filereadable(custom_gemfile) == 0 then
        vim.notify("❗ Ruby-LSP Gemfile not found: " .. custom_gemfile, vim.log.levels.WARN)
      end

      lspconfig.ruby_lsp.setup {
        capabilities = capabilities,
        filetypes = { "ruby", "eruby" },
        on_init = force_utf16,
        on_new_config = function(new_config, root)
          -- look up from the root for a `.overcommit` dir to support monorepo subdirectory roots
          local overcommit_dir = vim.fn.finddir(".overcommit", root .. ";")

          if overcommit_dir ~= "" then
            -- project uses shared overcommit bundle, load that override
            new_config.cmd     = { "bundle", "exec", "ruby-lsp", "stdio" }
            new_config.cmd_env = { BUNDLE_GEMFILE = custom_gemfile }
          elseif vim.fn.filereadable(root .. "/Gemfile") == 1 then
            -- project has its own Gemfile, use that
            new_config.cmd = { "bundle", "exec", "ruby-lsp", "stdio" }
            new_config.cmd_env = { BUNDLE_GEMFILE = root .. "/Gemfile" }
          else
            -- otherwise just invoke the globally-installed LSP
            new_config.cmd     = { "ruby-lsp" }
            new_config.cmd_env = nil
          end
        end,
      }

      -- use solargraph for goto definition, which is not well supported in ruby-lsp yet
      lspconfig.solargraph.setup {
        capabilities = capabilities,
        filetypes    = { "ruby", "eruby" },
        on_init      = force_utf16,
        root_dir     = util.root_pattern("Gemfile", ".git"),
        settings     = {
          solargraph = {
            diagnostics = false, -- let ruby-lsp handle diagnostics
          },
        },
      }

      -- keybinds
      vim.keymap.set("n", "[g", ":lua vim.diagnostic.goto_prev()<cr>")
      vim.keymap.set("n", "]g", ":lua vim.diagnostic.goto_next()<cr>")
      vim.keymap.set("n", "<leader>d", ":lua vim.diagnostic.show()<cr>")
      vim.keymap.set("n", "<leader>r", ":lua vim.lsp.buf.rename()<cr>")
      vim.keymap.set("n", "<leader>ca", ":lua vim.lsp.buf.code_action()<cr>")

      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local c = vim.lsp.get_client_by_id(args.data.client_id)
          if not c then return end

          -- Format the current buffer on save
          vim.api.nvim_create_autocmd('BufWritePre', {
            buffer = args.buf,
            callback = function()
              vim.lsp.buf.format({ bufnr = args.buf, id = c.id })
            end,
          })
        end,
      })
    end,
  }
}
