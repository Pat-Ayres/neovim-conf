return {
  {
    'echasnovski/mini.nvim',
    config = function()
      -- [[
      -- statusline setup
      --
      -- prerequisites
      --
      -- icons
      -- git
      -- diff
      -- ]]

      local icons = require 'mini.icons'
      icons.setup()

      local git = require 'mini.git'
      git.setup()
      vim.keymap.set("n", "<leader>gbl", ":lefta vert Git blame -- %<cr>")
      local rhs = '<Cmd>lua MiniGit.show_at_cursor()<CR>'
      vim.keymap.set({ 'n', 'x' }, '<Leader>gs', rhs, { desc = 'Show at cursor' })

      local diff = require 'mini.diff'
      diff.setup()
      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = true }

      local surround = require 'mini.surround'
      surround.setup()


      -- [[
      -- comments setup
      --
      -- embed context aware commenting capabilities
      --
      -- ]]
      local comments = require 'mini.comment'
      comments.setup({
        options = {
          custom_commentstring = function()
            return require('ts_context_commentstring').calculate_commentstring() or vim.bo.commentstring
          end
        }
      })
    end
  }
}
