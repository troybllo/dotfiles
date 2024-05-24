return {
  {
    "craftzdog/solarized-osaka.nvim",
    lazy = true,
    priority = 1000,
    opts = function()
      return {
        transparent = true, -- Enable this to disable setting the background color
        terminal_colors = true, -- Configure the colors used when opening a `:terminal` in [Neovim](https://github.com/neovim/neovim)
        styles = {
          -- Style to be applied to different syntax groups
          -- Value is any valid attr-list value for `:help nvim_set_hl`
          comments = { italic = true },
          keywords = { italic = true },
          functions = {},
          variables = {},
          -- Background styles. Can be "dark", "transparent" or "normal"
          sidebars = "dark", -- style for sidebars, see below
          floats = "dark", -- style for floating windows
        },
        sidebars = { "qf", "help" }, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
        day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
        hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
        dim_inactive = false, -- dims inactive windows
        lualine_bold = false,
      }
    end,
  },

  {
    "sainnhe/sonokai",
    priority = 1000,
    lazy = true,
    config = function()
      vim.g.sonokai_transparent_background = "1"
      vim.g.sonokai_enable_italic = "1"
      vim.g.sonokai_style = "andromeda"
      vim.cmd.colorscheme("sonokai")
    end,
  },

  {
    "morhetz/gruvbox",
    lazy = true,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("gruvbox")
      vim.g.gruvbox_bold = "1"
      vim.g.gruvbox_transparent_bg = "1"
      vim.g.gruvbox_termcolors = "16"
    end,
  },

  {
    "navarasu/onedark.nvim",
    lazy = true,
    priority = 1000,
    opts = function()
      return {
        style = "warmer", -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
        transparent = false, -- Show/hide background
        term_colors = true, -- Change terminal color as per the selected theme style
        ending_tildes = false, -- Show the end-of-buffer tildes. By default they are hidden
        cmp_itemkind_reverse = false, -- reverse item kind highlights in cmp menu

        -- toggle theme style ---
        toggle_style_key = nil, -- keybind to toggle theme style. Leave it nil to disable it, or set it to a string, for example "<leader>ts"
        toggle_style_list = { "dark", "darker", "cool", "deep", "warm", "warmer", "light" }, -- List of styles to toggle between

        -- Change code style ---
        -- Options are italic, bold, underline, none
        -- You can configure multiple style with comma separated, For e.g., keywords = 'italic,bold'
        code_style = {
          comments = "italic",
          keywords = "bold",
          functions = "bold",
          strings = "none",
          variables = "none",
        },

        -- Lualine options --
        lualine = {
          transparent = false, -- lualine center bar transparency
        },

        -- Custom Highlights --
        colors = {}, -- Override default colors
        highlights = {}, -- Override highlight groups

        -- Plugins Config --
        diagnostics = {
          darker = true, -- darker colors for diagnostic
          undercurl = true, -- use undercurl instead of underline for diagnostics
          background = true, -- use background color for virtual text
        },
      }
    end,
  },

  {
    "tiagovla/tokyodark.nvim",
    lazy = true,
    opts = {
      -- custom options here
    },
    config = function(_, opts)
      require("tokyodark").setup(opts) -- calling setup is optional
      vim.cmd([[colorscheme tokyodark]])
    end,
  },

  -- somewhere in your config:

  {
    "ellisonleao/gruvbox.nvim",
    name = "gruvbox",
    priority = 1000,
    opts = ...,
    config = function()
      return {
        require("gruvbox").setup({
          terminal_colors = true, -- add neovim terminal colors
          undercurl = true,
          underline = true,
          bold = true,
          italic = {
            strings = true,
            emphasis = true,
            comments = true,
            operators = false,
            folds = true,
          },
          strikethrough = true,
          invert_selection = false,
          invert_signs = false,
          invert_tabline = false,
          invert_intend_guides = false,
          inverse = true, -- invert background for search, diffs, statuslines and errors
          contrast = "hard", -- can be "hard", "soft" or empty string
          palette_overrides = {
            faded_red = "#f96078",
            bright_red = "#f96078",
            dark_red_hard = "#f96078",
            faded_purple = "#D3869B",
            bright_purple = "#D3869B",
          },
          overrides = {
            String = { bold = true },
          },
          dim_inactive = false,
          transparent_mode = false,
        }),
        vim.cmd("colorscheme gruvbox"),
      }
    end,
  },
  {
    "sainnhe/gruvbox-material",
    priority = 1000,
    lazy = true,
    name = "gruvbox-mat",
  },

  {
    "AstroNvim/astrotheme",
    priority = 1000,
    config = function()
      return {
        require("astrotheme").setup({
          palette = "astrodark", -- String of the default palette to use when calling `:colorscheme astrotheme`
          background = { -- :h background, palettes to use when using the core vim background colors
            light = "astrolight",
            dark = "astrodark",
          },

          style = {
            transparent = false, -- Bool value, toggles transparency.
            inactive = true, -- Bool value, toggles inactive window color.
            float = true, -- Bool value, toggles floating windows background colors.
            neotree = true, -- Bool value, toggles neo-trees background color.
            border = true, -- Bool value, toggles borders.
            title_invert = true, -- Bool value, swaps text and background colors.
            italic_comments = true, -- Bool value, toggles italic comments.
            simple_syntax_colors = true, -- Bool value, simplifies the amounts of colors used for syntax highlighting.
          },

          termguicolors = true, -- Bool value, toggles if termguicolors are set by AstroTheme.

          terminal_color = true, -- Bool value, toggles if terminal_colors are set by AstroTheme.

          plugin_default = "auto", -- Sets how all plugins will be loaded
          -- "auto": Uses lazy / packer enabled plugins to load highlights.
          -- true: Enables all plugins highlights.
          -- false: Disables all plugins.

          plugins = { -- Allows for individual plugin overrides using plugin name and value from above.
            ["bufferline.nvim"] = false,
          },
        }),
      }
    end,
  },

  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      term_colors = true,
      transparent_background = false,
      styles = {
        comments = {},
        conditionals = {},
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
      },
      color_overrides = {
        mocha = {
          base = "#000000",
          mantle = "#000000",
          crust = "#000000",
        },
      },
      integrations = {
        telescope = {
          enabled = true,
          style = "nvchad",
        },
        dropbar = {
          enabled = true,
          color_mode = true,
        },
      },
    },
  },
}
