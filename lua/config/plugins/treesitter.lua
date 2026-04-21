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

      require('nvim-treesitter').setup()

      require('nvim-treesitter').install({
        "c", "lua", "rust", "ruby", "go", "make",
        "awk", "bash", "bpftrace", "c_sharp", "cpp", "d", "dockerfile",
        "git_config", "gitignore", "gnuplot", "gosum", "graphql", "helm",
        "html", "ini", "java", "javascript", "jq", "json", "jsonnet",
        "markdown", "mermaid", "python", "rego", "sql", "ssh_config",
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
