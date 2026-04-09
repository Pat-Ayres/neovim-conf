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
        defaults = {
          -- nvim-treesitter v1 removed the parsers module telescope 0.1.8 depends on;
          -- disable telescope's treesitter highlighter and rely on native vim.treesitter
          preview = {
            treesitter = false,
          },
        },
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

      -- third-party previewers (e.g. zk-nvim) call buffer_previewer_maker without a
      -- preview key, so file_maker defaults treesitter back to true, breaking against
      -- nvim-treesitter v1 which removed ft_to_lang. Wrap the configured maker to
      -- ensure treesitter=false is the nil-fallback for any caller that omits it.
      local conf = require("telescope.config").values
      local orig_bpm = conf.buffer_previewer_maker
      conf.buffer_previewer_maker = function(filepath, bufnr, opts)
        opts = vim.F.if_nil(opts, {})
        opts.preview = vim.F.if_nil(opts.preview, {})
        opts.preview.treesitter = vim.F.if_nil(opts.preview.treesitter, false)
        orig_bpm(filepath, bufnr, opts)
      end

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
