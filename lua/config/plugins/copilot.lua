return {
  {
    -- GitHub Copilot Vim plugin
    "github/copilot.vim",
    -- Lazy-load when entering insert mode for minimal startup impact
    event = "InsertEnter",
    -- Optional configuration
    config = function()
      -- Disable Copilot's default <Tab> mapping
      vim.g.copilot_no_tab_map = true
      -- Map <C-j> to accept Copilot suggestion
      vim.keymap.set("i", "<C-j>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
    end,
  }
}
