return {
  {
    "craftzdog/solarized-osaka.nvim",
    lazy = false,
    priority = 1000,
    opts = function()
      return {
        transparent = true, -- Enable this to disable setting the background color
        terminal_colors = true, -- Configure the colors used when opening a `:terminal` in [Neovim](https://github.com/neovim/neovim)
        styles = {
          -- Style to be applied to different syntax groups
          -- Value is any valid attr-list value for `:help nvim_set_hl`
          comments = { italic = false },
          keywords = { italic = false },
          functions = { italic = false },
          variables = { italic = false, bold = false },
          conditionals = { italic = false },
          -- Background styles. Can be "dark", "transparent" or "normal"
          sidebars = "transparent", -- style for sidebars, see below
          floats = "transparent", -- style for floating windows
        },
        sidebars = {}, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
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
    "cryptomilk/nightcity.nvim",
    style = "kabuki", -- The theme comes in two styles: kabuki or afterlife
    terminal_colors = true, -- Use colors used when opening a `:terminal`
    invert_colors = {
      -- Invert colors for the following syntax groups
      cursor = true,
      diff = true,
      error = true,
      search = true,
      selection = false,
      signs = false,
      statusline = true,
      tabline = false,
    },
    font_style = {
      -- Style to be applied to different syntax groups
      comments = { italic = true },
      keywords = { italic = true },
      functions = { bold = true },
      variables = {},
      search = { bold = true },
    },
    -- Plugin integrations. Use `default = false` to disable all integrations.
    plugins = { default = true },
    --- You can override specific highlights to use other groups or a hex color
    --- function will be called with a Highlights and ColorScheme table
  },

  {
    "metalelf0/base16-black-metal-scheme",
    lazy = true,
    priority = 1000,
    config = function()
      vim.cmd("colorscheme base16-black-metal-gorgoroth")

      -- Ensure transparency for Neovim UI elements
      vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
      vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
      vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
      vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })
    end,
  },

  {
    "vague2k/vague.nvim",
    config = function()
      require("vague").setup({
        -- optional configuration here
        transparent = true,
        style = {
          -- "none" is the same thing as default. But "italic" and "bold" are also valid options
          boolean = "none",
          number = "none",
          float = "none",
          error = "none",
          comments = "italic",
          conditionals = "none",
          functions = "bold",
          headings = "bold",
          operators = "none",
          strings = "none",
          variables = "none",

          -- keywords
          keywords = "none",
          keyword_return = "none",
          keywords_loop = "none",
          keywords_label = "none",
          keywords_exception = "none",

          -- builtin
          builtin_constants = "none",
          builtin_functions = "none",
          builtin_types = "none",
          builtin_variables = "none",
        },
        colors = {
          func = "#bc96b0",
          keyword = "#787bab",
          -- string = "#d4bd98",
          string = "#8a739a",
          -- string = "#f2e6ff",
          -- number = "#f2e6ff",
          -- string = "#d8d5b1",
          number = "#8f729e",
          -- type = "#dcaed7",
        },
      })
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

  {
    "rose-pine/neovim",
    lazy = true,
    priority = 1000,
    name = "rose-pine",
    config = function()
      return {
        require("rose-pine").setup({
          variant = "dawn", -- auto, main, moon, or dawn
          dark_variant = "main", -- main, moon, or dawn
          dim_inactive_windows = false,
          extend_background_behind_borders = true,

          enable = {
            terminal = true,
            legacy_highlights = true, -- Improve compatibility for previous versions of Neovim
            migrations = true, -- Handle deprecated options automatically
          },

          styles = {
            bold = true,
            italic = false,
            transparency = false,
          },

          groups = {
            border = "muted",
            link = "iris",
            panel = "surface",

            error = "love",
            hint = "iris",
            info = "foam",
            note = "pine",
            todo = "rose",
            warn = "gold",

            git_add = "foam",
            git_change = "rose",
            git_delete = "love",
            git_dirty = "rose",
            git_ignore = "muted",
            git_merge = "iris",
            git_rename = "pine",
            git_stage = "iris",
            git_text = "rose",
            git_untracked = "subtle",

            h1 = "iris",
            h2 = "foam",
            h3 = "rose",
            h4 = "gold",
            h5 = "pine",
            h6 = "foam",
          },

          palette = {
            -- Override the builtin palette per variant
            -- moon = {
            --     base = '#18191a',
            --     overlay = '#363738',
            -- },
          },

          highlight_groups = {
            -- Comment = { fg = "foam" },
            -- VertSplit = { fg = "muted", bg = "muted" },
          },

          before_highlight = function(group, highlight, palette)
            -- Disable all undercurls
            -- if highlight.undercurl then
            --     highlight.undercurl = false
            -- end
            --
            -- Change palette colour
            -- if highlight.fg == palette.pine then
            --     highlight.fg = palette.foam
            -- end
          end,
        }),

        vim.cmd("colorscheme rose-pine"),
        -- vim.cmd("colorscheme rose-pine-main")
        -- vim.cmd("colorscheme rose-pine-moon")
        -- vim.cmd("colorscheme rose-pine-dawn")
      }
    end,
  },

  -- somewhere in your config:

  {
    "ellisonleao/gruvbox.nvim",
    lazy = true,
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
            strings = false,
            emphasis = true,
            comments = false,
            operators = false,
            folds = true,
          },
          strikethrough = true,
          invert_selection = false,
          invert_signs = false,
          invert_tabline = false,
          invert_intend_guides = false,
          inverse = false, -- invert background for search, diffs, statuslines and errors
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
            ["@variable.builtin"] = { fg = "#efb8da" },
            pythonBuiltin = { fg = "#efb8da" },
            pythonBuiltinObj = { fg = "#efb8da" },
            pythonBuiltinFunc = { fg = "#efb8da" },
          },
          dim_inactive = false,
          transparent_mode = true,
        }),
        vim.cmd("colorscheme gruvbox"),
      }
    end,
  },

  {
    "shaunsingh/nord.nvim", -- Add the Nord theme plugin
    lazy = true,
    priority = 1000,
    config = function()
      vim.g.nord_contrast = false
      vim.g.nord_borders = false
      vim.g.nord_disable_background = false
      vim.g.nord_italic = false
      vim.g.nord_uniform_diff_background = true
      vim.g.nord_bold = false
      require("nord").set() -- Load the Nord theme
    end,
  },

  {
    "slugbyte/lackluster.nvim",
    lazy = true,
    priority = 1000,
    config = function()
      return {
        require("lackluster").setup({
          -- You can overwrite the following syntax colors by setting them to one of...
          --   1) a hexcode like "#a1b2c3" for a custom color.
          --   2) "default" or nil will just use whatever lackluster's default is.
          tweak_syntax = {
            string = "default",
            -- string = "#a1b2c3", -- custom hexcode
            -- string = color.green, -- lackluster color
            string_escape = "default",
            comment = "#DEEEED",
            builtin = "#DDDDDD", -- builtin modules and functions
            type = "#DEEEED",
            keyword = "default",
            keyword_return = "#708090",
            keyword_exception = "#708090",
          },

          tweak_highlight = {
            -- modify @keyword's highlights to be bold and italic
            ["@keyword"] = {
              overwrite = false, -- overwrite falsey will extend/update lackluster's defaults (nil also does this)
              bold = true,
              italic = true,
              -- see `:help nvim_set_hl` for all possible keys
            },
            -- overwrite @function to link to @keyword
            ["@function"] = {
              overwrite = true, -- overwrite == true will force overwrite lackluster's default highlights
              link = "@keyword",
            },
          },

          tweak_background = {

            normal = "none", -- main background
            -- normal = 'none',    -- transparent
            -- normal = '#a1b2c3',    -- hexcode
            -- normal = color.green,    -- lackluster color
            telescope = "none", -- telescope
            menu = "none", -- nvim_cmp, wildmenu ... (bad idea to transparent)
            popup = "none", -- lazy, mason, whichkey ... (bad idea to transparent)
          },
        }),
        vim.cmd([[
    highlight LspReferenceText guifg=#ffffff guibg=NONE gui=bold
    highlight LspReferenceRead guifg=#ffffff guibg=NONE gui=bold
    highlight LspReferenceWrite guifg=#ffffff guibg=NONE gui=bold
]]),
        vim.cmd.colorscheme("lackluster"),
        vim.cmd.colorscheme("lackluster-hack"), -- my favorite
        vim.cmd.colorscheme("lackluster-mint"),
      }
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.options.theme = "nord" -- Set the lualine theme to 'nord'
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
            transparent = true, -- Bool value, toggles transparency.
            inactive = false, -- Bool value, toggles inactive window color.
            float = true, -- Bool value, toggles floating windows background colors.
            neotree = false, -- Bool value, toggles neo-trees background color.
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
