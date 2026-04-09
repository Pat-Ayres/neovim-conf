return {
  {
    "zk-org/zk-nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("zk").setup({
        picker = "telescope",
        lsp = {
          config = {
            -- wire blink.cmp capabilities into the zk LSP client
            capabilities = require("blink.cmp").get_lsp_capabilities(),
          },
        },
      })

      -- New note (prompts for title)
      vim.keymap.set("n", "<leader>zn", function()
        vim.ui.input({ prompt = "Note title: " }, function(title)
          if title and title ~= "" then
            require("zk.commands").get("ZkNew")({ title = title })
          end
        end)
      end, { desc = "zk: new note" })

      -- Backlinks via Telescope
      vim.keymap.set("n", "<leader>zb", "<cmd>ZkBacklinks<cr>", { desc = "zk: backlinks" })
    end,
  },
}
