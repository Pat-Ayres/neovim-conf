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

      -- Register the third-party asciidoc grammars (cathaysia/tree-sitter-asciidoc)
      -- so markview can render .adoc files. They are not in nvim-treesitter's
      -- registry, so add them as custom parsers. AsciiDoc uses two cooperating
      -- grammars living in subdirectories of one monorepo; `location` is the
      -- compile dir, `queries` is resolved relative to the repo root.
      local function register_asciidoc()
        local ts_parsers = require('nvim-treesitter.parsers')
        local rev = '6bfd7b291565a7b31e7524f6a563ac4a396e72ed'
        ts_parsers.asciidoc = {
          install_info = {
            url = 'https://github.com/cathaysia/tree-sitter-asciidoc',
            revision = rev,
            location = 'tree-sitter-asciidoc',
            queries = 'tree-sitter-asciidoc/queries',
          },
        }
        ts_parsers.asciidoc_inline = {
          install_info = {
            url = 'https://github.com/cathaysia/tree-sitter-asciidoc',
            revision = rev,
            location = 'tree-sitter-asciidoc_inline',
            queries = 'tree-sitter-asciidoc_inline/queries',
          },
        }
      end

      -- nvim-treesitter reloads its parser table on update and fires User TSUpdate;
      -- re-apply on that event, and apply once now so install() below can find them.
      vim.api.nvim_create_autocmd('User', {
        pattern = 'TSUpdate',
        callback = register_asciidoc,
      })
      register_asciidoc()

      require('nvim-treesitter').install({
        "c", "lua", "rust", "ruby", "go", "make",
        "asciidoc", "asciidoc_inline",
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
          'asciidoc',
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
