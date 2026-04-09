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

      -- Navigation
      vim.keymap.set("n", "<leader>zo", "<cmd>ZkNotes<cr>",  { desc = "zk: browse notes" })
      vim.keymap.set("n", "<leader>zt", "<cmd>ZkTags<cr>",   { desc = "zk: browse tags" })
      vim.keymap.set("n", "<leader>zl", "<cmd>ZkLinks<cr>",  { desc = "zk: forward links" })

      -- Visual-mode: selection-based operations
      vim.keymap.set("v", "<leader>zn", ":'<,'>ZkNewFromTitleSelection<cr>",   { desc = "zk: new note from selection (title)" })
      vim.keymap.set("v", "<leader>ze", ":'<,'>ZkNewFromContentSelection<cr>", { desc = "zk: extract selection to new note" })
      vim.keymap.set("v", "<leader>zm", ":'<,'>ZkMatch<cr>",                   { desc = "zk: find notes matching selection" })
    end,
  },
}
