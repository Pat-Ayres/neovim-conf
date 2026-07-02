-- [[
-- Markdown in-buffer rendering.
--
-- Two renderers are installed side by side so they can be test-driven.
-- Only one loads per session, selected by the NVIM_MD_RENDERER env var:
--
--   markview          (default) -- OXY2DEV/markview.nvim
--   render-markdown              -- MeanderingProgrammer/render-markdown.nvim
--
-- Switch by setting the env var and restarting Neovim:
--   NVIM_APPNAME=nvimdev nvim                                   -> markview
--   NVIM_MD_RENDERER=render-markdown NVIM_APPNAME=nvimdev nvim  -> render-markdown
--
-- lazy.nvim `cond` gates loading: only the selected renderer is loaded (and,
-- if not yet present, cloned on that first startup). The other stays dormant
-- and is not added to the runtimepath. Both are already installed locally, so
-- switching is instant; on a fresh machine the first switch clones once.
--
-- Both reuse the mini.icons provider already configured in mini.lua.
-- Both need the `markdown` and `markdown_inline` treesitter parsers, which are
-- installed in treesitter.lua.
-- ]]

local renderer = (vim.env.NVIM_MD_RENDERER or "markview"):lower()

return {
  {
    "OXY2DEV/markview.nvim",
    cond = renderer == "markview",
    -- markview manages its own buffer attachment; the maintainer recommends
    -- against lazy-loading it, so load eagerly (the cond gate above still keeps
    -- it dormant when render-markdown is selected).
    lazy = false,
    dependencies = { "echasnovski/mini.nvim" },
    config = function()
      require("markview").setup({
        -- Reuse mini.icons instead of pulling in nvim-web-devicons.
        preview = {
          icon_provider = "mini",
          -- Setting filetypes replaces markview's default list, so re-list the
          -- defaults plus asciidoc. Parsers registered in treesitter.lua.
          filetypes = { "markdown", "asciidoc", "quarto", "rmd", "typst" },
        },
        -- Render .adoc files (cathaysia/tree-sitter-asciidoc parsers required).
        asciidoc = {
          enable = true,
        },
        -- Default heading style already matches the boxed-number look; leaving
        -- markdown.headings unset keeps that default. Alternative presets:
        -- local presets = require("markview.presets")
        -- markdown = { headings = presets.glow },
      })
    end,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    cond = renderer == "render-markdown",
    ft = { "markdown" },
    dependencies = { "echasnovski/mini.nvim" },
    config = function()
      require("render-markdown").setup({
        -- Gutter markers next to headings, matching the markview look.
        heading = {
          sign = true,
        },
        -- render-markdown auto-detects mini.icons for code-block language icons.
      })
    end,
  },
}
