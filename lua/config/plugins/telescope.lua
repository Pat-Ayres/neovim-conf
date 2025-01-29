return {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
    },
    config = function()
      require('telescope').setup {
        pickers = {
          find_files = {
            theme = "ivy"
          }
        },
        extensions = {
          fzf = {}
        }
      }

      require('telescope').load_extension('fzf')

      vim.keymap.set("n", "<leader>fh", require('telescope.builtin').help_tags)
      vim.keymap.set("n", "<leader>fd", require('telescope.builtin').find_files)
      vim.keymap.set("n", "<leader>fb", require('telescope.builtin').buffers)
      vim.keymap.set("n", "<leader>fk", require('telescope.builtin').keymaps)
      vim.keymap.set("n", "<leader>ft", require('telescope.builtin').treesitter)
      vim.keymap.set("n", "<leader>gd", require('telescope.builtin').lsp_definitions)
      vim.keymap.set("n", "<leader>gt", require('telescope.builtin').lsp_type_definitions)

      -- search configs
      vim.keymap.set("n", "<space>en", function()
        require('telescope.builtin').find_files {
          cwd = vim.fn.stdpath("config")
        }
      end)

      -- search plugins source
      vim.keymap.set("n", "<space>ep", function()
        require('telescope.builtin').find_files {
          cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy")
        }
      end)

      -- search with hidden files
      vim.keymap.set("n", "<space>ff", function()
        require('telescope.builtin').find_files {
          hidden = true
        }
      end)

      require "config.telescope.multigrep".setup()
    end
  }
}
