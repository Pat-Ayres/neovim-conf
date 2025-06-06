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
      local capabilities = require('blink.cmp').get_lsp_capabilities()

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

      lspconfig.ruby_lsp.setup { capabilities = capabilities }

      -- keybinds
      vim.keymap.set("n", "[g", ":lua vim.diagnostic.goto_prev()<cr>")
      vim.keymap.set("n", "]g", ":lua vim.diagnostic.goto_next()<cr>")
      vim.keymap.set("n", "<leader>d", ":lua vim.diagnostic.show()<cr>")
      vim.keymap.set("n", "<leader>r", ":lua vim.lsp.buf.rename()<cr>")

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
