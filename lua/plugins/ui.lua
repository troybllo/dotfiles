local lualine = require("lualine")
local dap = require("dap")

dap.configurations.java = {
  {
    type = "java",
    request = "launch",
    name = "Launch Java Program",
  },
}

vim.fn.sign_define("DapBreakpoint", {
  text = "🔴",
  texthl = "DapBreakpointSymbol",
  linehl = "DapBreakpoint",
  numhl = "DapBreakpoint",
})
vim.fn.sign_define("DapStopped", {
  texthl = "DapStoppedSymbol",
  linehl = "CursorLine",
  numhl = "DapBreakpoint",
})

vim.keymap.set("n", "<F5>", function()
  require("dap").continue()
end)
vim.keymap.set("n", "<F10>", function()
  require("dap").step_over()
end)
vim.keymap.set("n", "<F11>", function()
  require("dap").step_into()
end)
vim.keymap.set("n", "<F12>", function()
  require("dap").step_out()
end)
vim.keymap.set("n", "<Leader>b", function()
  require("dap").toggle_breakpoint()
end)

local dapui = require("dapui")
dapui.setup()

dap.listeners.before.attach.dapui_config = function()
  dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
  dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
  --dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
  --dapui.close()
end

vim.keymap.set("n", "<Leader>du", function()
  dapui.toggle()
end)

return {

  -- messages, cmdline and the popupmenu
  {
    "folke/noice.nvim",
    opts = function(_, opts)
      table.insert(opts.routes, {
        filter = {
          event = "notify",
          find = "No information available",
        },
        opts = { skip = true },
      })
      local focused = true
      vim.api.nvim_create_autocmd("FocusGained", {
        callback = function()
          focused = true
        end,
      })
      vim.api.nvim_create_autocmd("FocusLost", {
        callback = function()
          focused = false
        end,
      })
      table.insert(opts.routes, 1, {
        filter = {
          cond = function()
            return not focused
          end,
        },
        view = "notify_send",
        opts = { stop = false },
      })

      opts.commands = {
        all = {
          -- options for the message history that you get with `:Noice`
          view = "split",
          opts = { enter = true, format = "details" },
          filter = {},
        },
      }
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function(event)
          vim.schedule(function()
            require("noice.text.markdown").keys(event.buf)
          end)
        end,
      })

      opts.presets.lsp_doc_border = true
    end,
  },

  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      dashboard = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      notifier = {
        enabled = true,
        timeout = 3000,
      },
      quickfile = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      styles = {
        notification = {
          -- wo = { wrap = true } -- Wrap notifications
        },
      },
    },
    keys = {
      {
        "<leader>z",
        function()
          Snacks.zen()
        end,
        desc = "Toggle Zen Mode",
      },
      {
        "<leader>Z",
        function()
          Snacks.zen.zoom()
        end,
        desc = "Toggle Zoom",
      },
      {
        "<leader>.",
        function()
          Snacks.scratch()
        end,
        desc = "Toggle Scratch Buffer",
      },
      {
        "<leader>S",
        function()
          Snacks.scratch.select()
        end,
        desc = "Select Scratch Buffer",
      },
      {
        "<leader>n",
        function()
          Snacks.notifier.show_history()
        end,
        desc = "Notification History",
      },
      {
        "<leader>bd",
        function()
          Snacks.bufdelete()
        end,
        desc = "Delete Buffer",
      },
      {
        "<leader>cR",
        function()
          Snacks.rename.rename_file()
        end,
        desc = "Rename File",
      },
      {
        "<leader>gB",
        function()
          Snacks.gitbrowse()
        end,
        desc = "Git Browse",
      },
      {
        "<leader>gb",
        function()
          Snacks.git.blame_line()
        end,
        desc = "Git Blame Line",
      },
      {
        "<leader>gf",
        function()
          Snacks.lazygit.log_file()
        end,
        desc = "Lazygit Current File History",
      },
      {
        "<leader>gg",
        function()
          Snacks.lazygit()
        end,
        desc = "Lazygit",
      },
      {
        "<leader>gl",
        function()
          Snacks.lazygit.log()
        end,
        desc = "Lazygit Log (cwd)",
      },
      {
        "<leader>un",
        function()
          Snacks.notifier.hide()
        end,
        desc = "Dismiss All Notifications",
      },
      {
        "<c-/>",
        function()
          Snacks.terminal()
        end,
        desc = "Toggle Terminal",
      },
      {
        "<c-_>",
        function()
          Snacks.terminal()
        end,
        desc = "which_key_ignore",
      },
      {
        "]]",
        function()
          Snacks.words.jump(vim.v.count1)
        end,
        desc = "Next Reference",
        mode = { "n", "t" },
      },
      {
        "[[",
        function()
          Snacks.words.jump(-vim.v.count1)
        end,
        desc = "Prev Reference",
        mode = { "n", "t" },
      },
      {
        "<leader>N",
        desc = "Neovim News",
        function()
          Snacks.win({
            file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
            width = 0.6,
            height = 0.6,
            wo = {
              spell = false,
              wrap = false,
              signcolumn = "yes",
              statuscolumn = " ",
              conceallevel = 3,
            },
          })
        end,
      },
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          -- Setup some globals for debugging (lazy-loaded)
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end
          vim.print = _G.dd -- Override print to use snacks for `:=` command

          -- Create some toggle mappings
          Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
          Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
          Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
          Snacks.toggle.diagnostics():map("<leader>ud")
          Snacks.toggle.line_number():map("<leader>ul")
          Snacks.toggle
            .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
            :map("<leader>uc")
          Snacks.toggle.treesitter():map("<leader>uT")
          Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
          Snacks.toggle.inlay_hints():map("<leader>uh")
          Snacks.toggle.indent():map("<leader>ug")
          Snacks.toggle.dim():map("<leader>uD")
        end,
      })
    end,
  },

  {
    "j-hui/fidget.nvim",
    opts = {
      -- options
    },
  },

  {
    "rcarriga/nvim-notify",
    opts = {
      timeout = 5000,
    },
  },

  -- animations
  {
    "echasnovski/mini.animate",
    event = "VeryLazy",
    opts = function(_, opts)
      opts.scroll = {
        enable = true,
      }
    end,
  },

  {
    "Hitesh-Aggarwal/feline_one_monokai.nvim",
    event = "VeryLazy",
  },

  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons", -- optional dependency
    },
    opts = {
      -- configurations go here
    },
  },

  {
    "SmiteshP/nvim-navic",
    requires = { "nvim-navic" },
  },

  { "mistricky/codesnap.nvim", build = "make" },

  --[[
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    opts = function()
      local lualine_require = require("lualine_require")
      lualine_require.require = require
      local custom_gruvbox = require("lualine.themes.gruvbox")
      custom_gruvbox.insert.c.bg = "#3c3836"

      custom_gruvbox.insert.c.fg = "#a89984"

      vim.o.laststatus = vim.g.lualine_laststatus

      local opts = {
        options = {
          theme = "custom_gruvbox",
          section_separators = "",
          component_separators = "",
          globalstatus = vim.o.laststatus == 3,
          disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter" } },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "filename" },
          lualine_c = {
            "branch",
            function()
              return vim.fn["nvim_treesitter#statusline"](180)
            end,
            "diff",
            "diagnostics",
          },
          lualine_x = {},
          lualine_y = { "location" },
          lualine_z = { "filetype" },
        },
      }
      return opts
    end,
  },
]]
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {},
    config = function(_, opts)
-- Eviline config for lualine
-- Author: shadmansaleh
-- Credit: glepnir

-- Color table for highlights
-- stylua: ignore
local colors = {
  bg       = '',
  fg       = '#bbc2cf',
  yellow   = '#ECBE7B',
  cyan     = '#95B4B5',
  darkblue = '#081633',
  green    = '#98be65',
  orange   = '#FF8800',
  violet   = '#a9a1e1',
  magenta  = '#c678dd',
  blue     = '#51afef',
  red      = '#ec5f67',
}

      local conditions = {
        buffer_not_empty = function()
          return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
        end,
        hide_in_width = function()
          return vim.fn.winwidth(0) > 80
        end,
        check_git_workspace = function()
          local filepath = vim.fn.expand("%:p:h")
          local gitdir = vim.fn.finddir(".git", filepath .. ";")
          return gitdir and #gitdir > 0 and #gitdir < #filepath
        end,
      }

      local config = {
        options = {

          component_separators = "",
          section_separators = "",
          theme = {
            -- We are going to use lualine_c an lualine_x as left and
            -- right section. Both are highlighted by c theme .  So we
            -- are just setting default looks o statusline
            normal = { c = { fg = colors.fg, bg = colors.bg } },
            inactive = { c = { fg = colors.fg, bg = colors.bg } },
          },
        },
        sections = {
          -- these are to remove the defaults
          lualine_a = {},
          lualine_b = {},
          lualine_y = {},
          lualine_z = {},
          -- These will be filled later
          lualine_c = {},
          lualine_x = {},
        },
        inactive_sections = {
          -- these are to remove the defaults
          lualine_a = {},
          lualine_b = {},
          lualine_y = {},
          lualine_z = {},
          lualine_c = {},
          lualine_x = {},
        },
      }
      -- Inserts a component in lualine_c at left section
      local function ins_left(component)
        table.insert(config.sections.lualine_c, component)
      end

      -- Inserts a component in lualine_x at right section
      local function ins_right(component)
        table.insert(config.sections.lualine_x, component)
      end

      ins_left({
        -- mode component
        function()
          return ""
        end,
        color = function()
          -- auto change color according to neovims mode
          local mode_color = {
            n = colors.red,
            i = colors.green,
            v = colors.blue,
            [""] = colors.blue,
            V = colors.blue,
            c = colors.magenta,
            no = colors.red,
            s = colors.orange,
            S = colors.orange,
            [""] = colors.orange,
            ic = colors.yellow,
            R = colors.violet,
            Rv = colors.violet,
            cv = colors.red,
            ce = colors.red,
            r = colors.cyan,
            rm = colors.cyan,
            ["r?"] = colors.cyan,
            ["!"] = colors.red,
            t = colors.red,
          }
          return { fg = mode_color[vim.fn.mode()] }
        end,
        padding = { right = 1 },
      })

      ins_left({
        -- filesize component
        "filesize",
        cond = conditions.buffer_not_empty,
        color = { fg = colors.yellow, gui = "italic" },
      })

      ins_left({
        "filetype",

        icons_enabled = true,
        cond = conditions.buffer_not_empty,
        color = { fg = colors.cyan, gui = "bold" },
      })

      ins_left({ "location", color = { fg = colors.white, gui = "bold" } })

      ins_left({ "progress", color = { fg = colors.violet, gui = "bold" } })

      ins_left({
        "diagnostics",
        sources = { "nvim_diagnostic" },
        symbols = { error = " ", warn = " ", info = " " },
        diagnostics_color = {
          color_error = { fg = colors.red },
          color_warn = { fg = colors.yellow },
          color_info = { fg = colors.cyan },
        },
      })

      -- Insert mid section. You can make any number of sections in neovim :)
      -- for lualine it's any number greater then 2
      ins_left({
        function()
          return "%="
        end,

        ins_left({
          -- Lsp server name .
          function()
            local msg = "No Active Lsp"
            local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
            local clients = vim.lsp.get_active_clients()
            if next(clients) == nil then
              return msg
            end
            for _, client in ipairs(clients) do
              local filetypes = client.config.filetypes
              if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                return client.name
              end
            end
            return msg
          end,
          icon = " LSP:",
          color = { fg = "#ffffff", gui = "bold" },
        }),

        -- Add components to right sections
        ins_right({
          "o:encoding", -- option component same as &encoding in viml
          fmt = string.upper, -- I'm not sure why it's upper case either ;)
          cond = conditions.hide_in_width,
          color = { fg = colors.cyan, gui = "bold" },
        }),

        ins_right({
          "filename",
          icons_enabled = true,
          color = { fg = colors.yellow, gui = "bold" },
        }),

        ins_right({
          "fileformat",
          fmt = string.upper,
          icons_enabled = false, -- I think icons are cool but Eviline doesn't have them. sigh
          color = { fg = colors.cyan, gui = "bold" },
        }),

        ins_right({
          "branch",
          icon = "",
          color = { fg = colors.red, gui = "bold" },
        }),

        ins_right({
          "diff",
          -- Is it me or the symbol for modified us really weird
          symbols = { added = " ", modified = "󰝤 ", removed = " " },
          diff_color = {
            added = { fg = colors.cyan },
            modified = { fg = colors.orange },
            removed = { fg = colors.red },
          },
          cond = conditions.hide_in_width,
        }),
      })

      lualine.setup(config)
    end,
  },

  --]]

  -- buffer line
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      { "<Tab>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next tab" },
      { "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev tab" },
    },
    opts = {
      options = {
        mode = "tabs",
        themable = false,
        -- separator_style = "slant",
        show_buffer_close_icons = false,
        show_close_icon = false,
      },
    },
  },

  -- statusline

  --[[
  -- add discord presence
  {
    "andweeb/presence.nvim",
    event = "VeryLazy",
    opts = {
      auto_update = true, -- Update activity based on autocmd events (if `false`, map or manually execute `:lua package.loaded.presence:update()`)
      neovim_image_text = "Neovim", -- Text displayed when hovered over the Neovim image
      main_image = "file", -- Main image display (either "neovim" or "file")
      client_id = "793271441293967371", -- Use your own Discord application client id (not recommended)
      log_level = nil, -- Log messages at or above this level (one of the following: "debug", "info", "warn", "error")
      debounce_timeout = 10, -- Number of seconds to debounce events (or calls to `:lua package.loaded.presence:update(<filename>, true)`)
      enable_line_number = false, -- Displays the current line number instead of the current project
      blacklist = {}, -- A list of strings or Lua patterns that disable Rich Presence if the current file name, path, or workspace matches
      buttons = true, -- Configure Rich Presence button(s), either a boolean to enable/disable, a static table (`{{ label = "<label>", url = "<url>" }, ...}`, or a function(buffer: string, repo_url: string|nil): table)
      file_assets = {}, -- Custom file asset definitions keyed by file names and extensions (see default config at `lua/presence/file_assets.lua` for reference)
      show_time = true, -- Show the timer

      -- Rich Presence text options
      editing_text = "Editing %s", -- Format string rendered when an editable file is loaded in the buffer (either string or function(filename: string): string)
      file_explorer_text = "Browsing %s", -- Format string rendered when browsing a file explorer (either string or function(file_explorer_name: string): string)
      git_commit_text = "Committing changes", -- Format string rendered when committing changes in git (either string or function(filename: string): string)
      plugin_manager_text = "Managing plugins", -- Format string rendered when managing plugins (either string or function(plugin_manager_name: string): string)
      reading_text = "Reading %s", -- Format string rendered when a read-only or unmodifiable file is loaded in the buffer (either string or function(filename: string): string)
      workspace_text = "Working on %s", -- Format string rendered when in a git repository (either string or function(project_name: string|nil, filename: string): string)
      line_number_text = "Line %s out of %s",
    },
  },
    ]]
  --
  -- {
  --   "vyfor/cord.nvim",
  --   build = ":Cord update",
  --   event = "VeryLazy",
  --   opts = {
  --     usercmds = true, -- Enable user commands
  --     log_level = "error", -- One of 'trace', 'debug', 'info', 'warn', 'error', 'off'
  --     timer = {
  --       interval = 1500, -- Interval between presence updates in milliseconds (min 500)
  --       reset_on_idle = false, -- Reset start timestamp on idle
  --       reset_on_change = false, -- Reset start timestamp on presence change
  --     },
  --     editor = {
  --       image = nil, -- Image ID or URL in case a custom client id is provided
  --       client = "neovim", -- vim, neovim, lunarvim, nvchad, astronvim or your application's client id
  --       tooltip = "Neovim", -- Text to display when hovering over the editor's image
  --     },
  --     display = {
  --       show_time = true, -- Display start timestamp
  --       show_repository = true, -- Display 'View repository' button linked to repository url, if any
  --       show_cursor_position = false, -- Display line and column number of cursor's position
  --       swap_fields = false, -- If enabled, workspace is displayed first
  --       swap_icons = false, -- If enabled, editor is displayed on the main image
  --       workspace_blacklist = {}, -- List of workspace names that will hide rich presence
  --     },
  --     lsp = {
  --       show_problem_count = true, -- Display number of diagnostics problems
  --       severity = 1, -- 1 = Error, 2 = Warning, 3 = Info, 4 = Hint
  --       scope = "workspace", -- buffer or workspace
  --     },
  --     idle = {
  --       enable = true, -- Enable idle status
  --       show_status = true, -- Display idle status, disable to hide the rich presence on idle
  --       timeout = 300000, -- Timeout in milliseconds after which the idle status is set, 0 to display immediately
  --       disable_on_focus = false, -- Do not display idle status when neovim is focused
  --       text = "Idle", -- Text to display when idle
  --       tooltip = "💤", -- Text to display when hovering over the idle image
  --       icon = nil, -- Replace the default idle icon; either an asset ID or a URL
  --     },
  --     text = {
  --       viewing = "Viewing {}", -- Text to display when viewing a readonly file
  --       editing = "Editing {}", -- Text to display when editing a file
  --       file_browser = "Browsing files in {}", -- Text to display when browsing files (Empty string to disable)
  --       plugin_manager = "Managing plugins in {}", -- Text to display when managing plugins (Empty string to disable)
  --       lsp_manager = "Configuring LSP in {}", -- Text to display when managing LSP servers (Empty string to disable)
  --       vcs = "Committing changes in {}", -- Text to display when using Git or Git-related plugin (Empty string to disable)
  --       workspace = "In {}", -- Text to display when in a workspace (Empty string to disable)
  --     },
  --     buttons = {
  --       {
  --         label = "View Repository", -- Text displayed on the button
  --         url = "git", -- URL where the button leads to ('git' = automatically fetch Git repository URL)
  --       },
  --       -- {
  --       --   label = 'View Plugin',
  --       --   url = 'https://github.com/vyfor/cord.nvim',
  --       -- }
  --     },
  --     assets = nil, -- Custom file icons, see the wiki*
  --     -- assets = {
  --     --   lazy = {                                 -- Vim filetype or file name or file extension = table or string
  --     --     name = 'Lazy',                         -- Optional override for the icon name, redundant for language types
  --     --     icon = 'https://example.com/lazy.png', -- Rich Presence asset name or URL
  --     --     tooltip = 'lazy.nvim',                 -- Text to display when hovering over the icon
  --     --     type = 'plugin_manager',               -- One of 'language', 'file_browser', 'plugin_manager', 'lsp_manager', 'vcs' or respective ordinals; defaults to 'language'
  --     --   },
  --     --   ['Cargo.toml'] = 'crates',
  --     -- },
  --   }, -- calls require('cord').setup()
  -- },
  --

  {
    "vyfor/cord.nvim",
    build = ":Cord update",
    opts = function()
      return {
        enabled = true,
        log_level = vim.log.levels.OFF,
        editor = {
          client = "neovim",
          tooltip = "Neovim",
          icon = nil,
        },
        display = {
          theme = "onyx",
          swap_fields = false,
          swap_icons = false,
        },
        timestamp = {
          enabled = true,
          reset_on_idle = false,
          reset_on_change = false,
        },
        idle = {
          enabled = true,
          timeout = 300000,
          show_status = true,
          ignore_focus = true,
          unidle_on_focus = true,
          smart_idle = true,
          details = "Idling",
          state = nil,
          tooltip = "💤",
          icon = nil,
        },
        text = {
          workspace = function(opts)
            return "In " .. opts.workspace
          end,
          viewing = function(opts)
            return "Viewing " .. opts.filename
          end,
          editing = function(opts)
            return "Editing " .. opts.filename
          end,
          file_browser = function(opts)
            return "Browsing files in " .. opts.name
          end,
          plugin_manager = function(opts)
            return "Managing plugins in " .. opts.name
          end,
          lsp = function(opts)
            return "Configuring LSP in " .. opts.name
          end,
          docs = function(opts)
            return "Reading " .. opts.name
          end,
          vcs = function(opts)
            return "Committing changes in " .. opts.name
          end,
          notes = function(opts)
            return "Taking notes in " .. opts.name
          end,
          debug = function(opts)
            return "Debugging in " .. opts.name
          end,
          test = function(opts)
            return "Testing in " .. opts.name
          end,
          diagnostics = function(opts)
            return "Fixing problems in " .. opts.name
          end,
          games = function(opts)
            return "Playing " .. opts.name
          end,
          terminal = function(opts)
            return "Running commands in " .. opts.name
          end,
          dashboard = "Home",
        },
        buttons = nil,
        -- buttons = {
        --   {
        --     label = 'View Repository',
        --     url = function(opts) return opts.repo_url end,
        --   },
        -- },
        assets = nil,
        variables = nil,
        hooks = {
          ready = nil,
          shutdown = nil,
          pre_activity = nil,
          post_activity = nil,
          idle_enter = nil,
          idle_leave = nil,
          workspace_change = nil,
        },
        plugins = nil,
        advanced = {
          plugin = {
            autocmds = true,
            cursor_update = "on_hold",
            match_in_mappings = true,
          },
          server = {
            update = "fetch",
            pipe_path = nil,
            executable_path = nil,
            timeout = 300000,
          },
          discord = {
            reconnect = {
              enabled = false,
              interval = 5000,
              initial = true,
            },
          },
        },
      }
    end,
  },
  -- filename
  {
    "b0o/incline.nvim",
    dependencies = {},
    event = "BufReadPre",
    priority = 1200,
    config = function()
      local helpers = require("incline.helpers")
      require("incline").setup({
        window = {
          padding = 0,
          margin = { horizontal = 0 },
        },
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
          local ft_icon, ft_color = require("nvim-web-devicons").get_icon_color(filename)
          local modified = vim.bo[props.buf].modified
          local buffer = {
            ft_icon and { " ", ft_icon, " ", guibg = ft_color, guifg = helpers.contrast_color(ft_color) } or "",
            " ",
            { filename, gui = modified and "bold,italic" or "bold" },
            " ",
            guibg = "#363944",
          }
          return buffer
        end,
      })
    end,
  },

  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    init = function()
      -- Your DBUI configuration
      vim.g.db_ui_use_nerd_fonts = 1
    end,
    keys = {
      {

        "<leader>d",
        "<cmd>NvimTreeClose<cr><cmd>tabnew<cr><bar><bar><cmd>DBUI<cr>",
      },
    },

    {
      "SmiteshP/nvim-navic",
      dependencies = "neovim/nvim-lspconfig",
    },

    {
      "folke/zen-mode.nvim",
      cmd = "ZenMode",
      opts = {
        plugins = {
          gitsigns = true,
          tmux = true,
          kitty = { enabled = false, font = "+2" },
        },
      },
      keys = { { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" } },
    },

    {
      "nvimdev/dashboard-nvim",
      event = "VimEnter",
      opts = function(_, opts)
        local logo = [[


████████╗██████╗  ██████╗ ██╗   ██╗
╚══██╔══╝██╔══██╗██╔═══██╗╚██╗ ██╔╝
   ██║   ██████╔╝██║   ██║ ╚████╔╝ 
   ██║   ██╔══██╗██║   ██║  ╚██╔╝  
   ██║   ██║  ██║╚██████╔╝   ██║   
   ╚═╝   ╚═╝  ╚═╝ ╚═════╝    ╚═╝   
                                   
                                                          
                                   
      ]]

        logo = string.rep("\n", 8) .. logo .. "\n\n"
        opts.config.header = vim.split(logo, "\n")
      end,
    },
  },
}
