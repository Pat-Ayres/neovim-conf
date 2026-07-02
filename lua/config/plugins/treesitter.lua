return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      -- main branch stores queries under runtime/queries/, not queries/ directly
      local plugin_dir = vim.fn.stdpath("data") .. "/lazy/nvim-treesitter"
      vim.opt.runtimepath:append(plugin_dir .. "/runtime")

      -- Neovim 0.12 added vim.list.unique, which nvim-treesitter's main branch
      -- uses while normalizing the parser list during install(). On older builds
      -- (like a pre-0.12-dev nvim where vim.list is absent) every install()
      -- silently fails, so new parsers never compile. Define a compatible
      -- fallback until Neovim is upgraded; it is a no-op once the API exists.
      vim.list = vim.list or {}
      if not vim.list.unique then
        function vim.list.unique(list)
          local seen, out = {}, {}
          for _, v in ipairs(list) do
            if not seen[v] then
              seen[v] = true
              out[#out + 1] = v
            end
          end
          return out
        end
      end

      require('nvim-treesitter').setup()

      require('nvim-treesitter').install({
        "c", "lua", "rust", "ruby", "go", "make",
        "awk", "bash", "bpftrace", "c_sharp", "cpp", "d", "dockerfile",
        "git_config", "gitignore", "gnuplot", "gosum", "graphql", "helm",
        "html", "ini", "java", "javascript", "jq", "json", "jsonnet",
        "markdown", "markdown_inline", "mermaid", "python", "rego", "sql", "ssh_config",
        "strace", "terraform", "hcl", "toml", "typescript", "vim", "xml",
        "yaml", "zig",
      })

      -- Enable treesitter highlighting per filetype (c and rust intentionally excluded)
      vim.api.nvim_create_autocmd('FileType', {
        pattern = {
          'lua', 'ruby', 'go', 'make',
          'awk', 'bash', 'sh', 'bpftrace', 'cs', 'cpp', 'd', 'dockerfile',
          'gitconfig', 'gitignore', 'gnuplot', 'gosum', 'graphql', 'helm',
          'html', 'dosini', 'java', 'javascript', 'jq', 'json', 'jsonnet',
          'markdown', 'mermaid', 'python', 'rego', 'sql', 'sshconfig',
          'strace', 'terraform', 'hcl', 'toml', 'typescript', 'vim', 'xml',
          'yaml', 'zig',
        },
        callback = function()
          local lang = vim.treesitter.language.get_lang(vim.bo.filetype)
          if lang and pcall(vim.treesitter.language.inspect, lang) then
            vim.treesitter.start()
          end
        end,
      })
    end,
  }
}
