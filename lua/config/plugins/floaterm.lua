return {
  {
    "voldikss/vim-floaterm",
    config = function()
      -- <leader>mg: transient glow preview of the current buffer
      vim.keymap.set("n", "<leader>mg", function()
        local file = vim.fn.shellescape(vim.fn.expand("%:p"))
        vim.cmd("FloatermNew --name=glow --autoclose=2 --width=0.9 --height=0.9 glow -p " .. file)
      end, { desc = "Glow: preview buffer" })

      -- Resolve AI agent executable: prefer claude (Claude Code), fall back to agent (Cursor)
      local ai_cmd = vim.fn.executable("claude") == 1 and "claude"
                 or  vim.fn.executable("agent")  == 1 and "agent"
                 or  nil

      -- <leader>ca: persistent AI agent floaterm (create on first call, toggle thereafter)
      vim.keymap.set("n", "<leader>ca", function()
        if not ai_cmd then
          vim.notify("Neither 'claude' nor 'agent' found in PATH", vim.log.levels.ERROR)
          return
        end
        local bufnr = vim.fn["floaterm#terminal#get_bufnr"]("claude")
        if bufnr == -1 then
          vim.cmd("FloatermNew --name=claude --autoclose=0 --width=0.9 --height=0.9 " .. ai_cmd)
        else
          vim.cmd("FloatermToggle claude")
        end
      end, { desc = "AI agent floaterm (claude / agent)" })

      -- Exit terminal mode without closing the floaterm
      vim.keymap.set("t", "<C-]>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

      -- Re-enter terminal mode automatically when switching back to a terminal buffer
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "term://*",
        callback = function()
          vim.cmd("normal! G")
          vim.cmd("startinsert")
        end,
      })

      -- Resize any open floaterms when the Neovim window geometry changes
      -- (e.g. focusing a tmux pane that changes terminal dimensions)
      vim.api.nvim_create_autocmd("VimResized", {
        callback = function()
          for _, name in ipairs({ "glow", "claude" }) do
            if vim.fn["floaterm#terminal#get_bufnr"](name) ~= -1 then
              vim.cmd("FloatermUpdate --name=" .. name .. " --width=0.9 --height=0.9")
            end
          end
        end,
      })
    end,
  },
}
