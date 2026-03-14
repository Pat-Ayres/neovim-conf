return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require('nvim-treesitter').install({ "c", "lua", "rust", "ruby", "go", "make" })

      -- Enable treesitter highlighting per filetype (c and rust intentionally excluded)
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'lua', 'ruby', 'go', 'make' },
        callback = function() vim.treesitter.start() end,
      })
    end,
  }
}
