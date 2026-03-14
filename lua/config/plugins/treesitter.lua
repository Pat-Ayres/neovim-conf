return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
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
        callback = function() vim.treesitter.start() end,
      })
    end,
  }
}
