return {
  -- tools
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "stylua",
        "selene",
        "luacheck",
        "shellcheck",
        "shfmt",
        "tailwindcss-language-server",
        "typescript-language-server",
        "css-lsp",
        "jdtls",
        "vtsls",
        "zls",
      })
    end,
  },

  -- lsp servers
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = true },
      ---@type lspconfig.options
      servers = {
        cssls = {},
        tailwindcss = {
          root_dir = function(...)
            return require("lspconfig.util").root_pattern(".git")(...)
          end,
        },
        tsserver = {
          root_dir = function(...)
            return require("lspconfig.util").root_pattern(".git")(...)
          end,
          single_file_support = false,
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "literal",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = false,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
          },
        },
        html = {},
        yamlls = {
          settings = {
            yaml = {
              keyOrdering = false,
            },
          },
        },
        dartls = {
          cmd = { "dart", "language-server", "--protocol=lsp" },
          filetypes = { "dart" },
        },

        jdtls = {

          java_cmds = vim.api.nvim_create_augroup("java_cmds", { clear = true }),
          cache_vars = {},
          root_files = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle", "build.sbt" },
          features = {
            codelens = true, -- enable codelens
            debugger = true, -- enable debugger
          },

          function()
            if cache_vars.paths then
              return cache_vars.paths
            end
            local path = {}

            path.data_dir = vim.fn.stdpath("cache") .. "/nvim-jdtls"

            local jdtls_install = require("mason-registry").get_package("jdtls"):get_install_path()

            path.java_agent = jdtls_install .. "/lombok.jar"
            path.launcher_jar = vim.fn.glob(jdtls_install .. "/plugins/org.eclipse.equinox.launcher_*.jar")

            if vim.fn.has("mac") == 1 then
              path.platform_config = jdtls_install .. "/config_mac"
            elseif vim.fn.has("unix") == 1 then
              path.platform_config = jdtls_install .. "/config_linux"
            elseif vim.fn.has("win32") == 1 then
              path.platform_config = jdtls_install .. "/config_win"
            end

            path.bundles = {}

            -- Include java-test bundle if present
            local java_test_path = require("mason-registry").get_package("java-test"):get_install_path()

            local java_test_bundle = vim.split(vim.fn.glob(java_test_path .. "/extension/server/*.jar"), "\n")

            if java_test_bundle[1] ~= "" then
              vim.list_extend(path.bundles, java_test_bundle)
            end

            -- Include java-debug-adapter bundle if present
            local java_debug_path = require("mason-registry").get_package("java-debug-adapter"):get_install_path()

            local java_debug_bundle =
              vim.split(vim.fn.glob(java_debug_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar"), "\n")

            if java_debug_bundle[1] ~= "" then
              vim.list_extend(path.bundles, java_debug_bundle)
            end

            -- Useful if you're starting jdtls with a Java version that's different from the one the project uses.
            path.runtimes = {
              {
                name = "JavaSE-21",
                path = vim.fn.expand("~/.sdkman/candidates/java/21.0.2-tem"),
              },
              {
                name = "JavaSE-23",
                path = vim.fn.expand("~/.sdkman/candidates/java/23-tem"),
              },
            }

            cache_vars.paths = path

            return path
          end,

          function(bufnr)
            pcall(vim.lsp.codelens.refresh)
            vim.api.nvim_create_autocmd("BufWritePost", {
              buffer = bufnr,
              group = java_cmds,
              desc = "refresh codelens",
              callback = function()
                pcall(vim.lsp.codelens.refresh)
              end,
            })
          end,

          function(bufnr)
            require("jdtls").setup_dap({ hotcodereplace = "auto" })
            require("jdtls.dap").setup_dap_main_class_configs()
            local opts = { buffer = bufnr }
            vim.keymap.set("n", "<leader>df", "<cmd>lua require('jdtls').test_class()<cr>", opts)
            vim.keymap.set("n", "<leader>dn", "<cmd>lua require('jdtls').test_nearest_method()<cr>", opts)
          end,

          function(client, bufnr)
            if features.debugger then
              enable_debugger(bufnr)
            end
            if features.codelens then
              enable_codelens(bufnr)
            end

            -- The following mappings are based on the suggested usage of nvim-jdtls
            -- https://github.com/mfussenegger/nvim-jdtls#usage

            local opts = { buffer = bufnr }
            vim.keymap.set("n", "<A-o>", "<cmd>lua require('jdtls').organize_imports()<cr>", opts)
            vim.keymap.set("n", "crv", "<cmd>lua require('jdtls').extract_variable()<cr>", opts)
            vim.keymap.set("x", "crv", "<esc><cmd>lua require('jdtls').extract_variable(true)<cr>", opts)
            vim.keymap.set("n", "crc", "<cmd>lua require('jdtls').extract_constant()<cr>", opts)
            vim.keymap.set("x", "crc", "<esc><cmd>lua require('jdtls').extract_constant(true)<cr>", opts)
            vim.keymap.set("x", "crm", "<esc><Cmd>lua require('jdtls').extract_method(true)<cr>", opts)
            vim.keymap.set("n", "<leader>pjp", "<cmd>lua require('jdtls').javap()<cr>", opts)
          end,

          function(event)
            local jdtls = require("jdtls")
            local extendedClientCapabilities = jdtls.extendedClientCapabilities
            extendedClientCapabilities.onCompletionItemSelectedCommand = "editor.action.triggerParameterHints"

            local path = get_jdtls_paths()
            local data_dir = path.data_dir .. "/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

            if cache_vars.capabilities == nil then
              jdtls.extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

              local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
              cache_vars.capabilities = vim.tbl_deep_extend(
                "force",
                vim.lsp.protocol.make_client_capabilities(),
                ok_cmp and cmp_lsp.default_capabilities() or {}
              )
            end

            -- The command that starts the language server
            local cmd = {
              "java",
              "-Declipse.application=org.eclipse.jdt.ls.core.id1",
              "-Dosgi.bundles.defaultStartLevel=4",
              "-Declipse.product=org.eclipse.jdt.ls.core.product",
              "-Dlog.protocol=true",
              "-Dlog.level=ALL",
              "-javaagent:" .. path.java_agent,
              "-Xms1g",
              "--add-modules=ALL-SYSTEM",
              "--add-opens",
              "java.base/java.util=ALL-UNNAMED",
              "--add-opens",
              "java.base/java.lang=ALL-UNNAMED",
              "-jar",
              path.launcher_jar,
              "-configuration",
              path.platform_config,
              "-data",
              data_dir,
            }

            local lsp_settings = {
              java = {
                project = {
                  referencedLibraries = {},
                },
                eclipse = {
                  downloadSources = true,
                },
                configuration = {
                  updateBuildConfiguration = "interactive",
                  runtimes = path.runtimes,
                },
                maven = {
                  downloadSources = true,
                },
                implementationsCodeLens = {
                  enabled = true,
                },
                referencesCodeLens = {
                  enabled = true,
                },
                references = {
                  includeDecompiledSources = true,
                },
                inlayHints = {
                  enabled = true,
                },
                format = {
                  enabled = true,
                },
              },
              signatureHelp = {
                enabled = true,
              },
              completion = {
                favoriteStaticMembers = {
                  "org.hamcrest.MatcherAssert.assertThat",
                  "org.hamcrest.Matchers.*",
                  "org.hamcrest.CoreMatchers.*",
                  "org.junit.jupiter.api.Assertions.*",
                  "java.util.Objects.requireNonNull",
                  "java.util.Objects.requireNonNullElse",
                  "org.mockito.Mockito.*",
                },
              },
              contentProvider = {
                preferred = "fernflower",
              },
              extendedClientCapabilities = jdtls.extendedClientCapabilities,
              sources = {
                organizeImports = {
                  starThreshold = 9999,
                  staticStarThreshold = 9999,
                },
              },
              codeGeneration = {
                toString = {
                  template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
                },
                useBlocks = true,
              },
            }

            local dap = require("dap")

            dap.configurations.java = {
              {
                type = "java",
                request = "launch",
                name = "Launch Java Program",
              },
            }

            -- Configure breakpoint and stopped signs
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

            -- Key mappings for debugging
            vim.keymap.set("n", "<F5>", function()
              dap.continue()
            end)
            vim.keymap.set("n", "<F10>", function()
              dap.step_over()
            end)
            vim.keymap.set("n", "<F11>", function()
              dap.step_into()
            end)
            vim.keymap.set("n", "<F12>", function()
              dap.step_out()
            end)
            vim.keymap.set("n", "<Leader>b", function()
              dap.toggle_breakpoint()
            end)

            -- Set up DAP UI
            local dapui = require("dapui")
            dapui.setup()

            -- Automatically open DAP UI when debugging starts
            dap.listeners.before.attach.dapui_config = function()
              dapui.open()
            end
            dap.listeners.before.launch.dapui_config = function()
              dapui.open()
            end

            -- Close DAP UI when the session terminates or exits
            dap.listeners.before.event_terminated.dapui_config = function()
              dapui.close()
            end
            dap.listeners.before.event_exited.dapui_config = function()
              dapui.close()
            end

            -- Toggle DAP UI with a keybinding
            vim.keymap.set("n", "<Leader>du", function()
              dapui.toggle()
            end)

            -- This starts a new client & server, or attaches to an existing client & server depending on the root_dir.
            jdtls.start_or_attach({
              cmd = cmd,
              settings = lsp_settings,
              on_attach = jdtls_on_attach,
              capabilities = cache_vars.capabilities,
              root_dir = jdtls.setup.find_root(root_files),
              flags = {
                allow_incremental_sync = true,
              },
              init_options = {
                bundles = path.bundles,
                extendedClientCapabilities = extendedClientCapabilities,
              },
            })
          end,

          vim.api.nvim_create_autocmd("FileType", {
            group = java_cmds,
            pattern = { "java" },
            desc = "Setup jdtls",
            callback = jdtls_setup,
          }),

          omnisharp = {
            cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
            root_dir = function()
              return require("lspconfig.util").root_pattern("*.sln", "*.csproj")(vim.fn.getcwd())
            end,
            settings = {
              omnisharp = {
                disableMSBuildSupport = false,
                enableRoslynAnalyzers = true,
                organizeImports = true,
                formatting = {
                  enable = true,
                  style = "Allman",
                },
              },
            },
          },

          zls = {
            zig_exe_path = "~/zig-macos-aarch64-0.13.0-dev.345+103b885fc",
            path = "~/gameDev/zls/zig-out/bin/zls",
            cmd = { "zls", "--enable-debug-log", "~/gameDev/zls/zig-out/bin/zls" },
            filetypes = { "zig" },
            completion = {
              workspaceWord = true,
              callSnippet = "Both",
            },

            settings = {
              zls = {
                zig_exe_path = "~/zig-macos-aarch64-0.13.0-dev.345+103b885fc",
              },
            },
            root_dir = function(...)
              return require("lspconfig.util").root_pattern(".git")(...)
            end,
          },
          clangd = {
            cmd = {
              "clangd",
              "--offset-encoding=utf-16",
            },
            includePath = {
              "/opt/homebrew/include", -- Path to GLFW headers
              "/opt/homebrew/Cellar/gtk+3/3.24.42/include",
            },
            root_dir = function(...)
              return require("lspconfig.util").root_pattern(".git")(...)
            end,
          },
          rust_analyzer = {
            keys = {
              { "K", "<cmd>RustHoverActions<cr>", desc = "Hover Actions (Rust)" },
              { "<leader>cR", "<cmd>RustCodeAction<cr>", desc = "Code Action (Rust)" },
              { "<leader>dr", "<cmd>RustDebuggables<cr>", desc = "Run Debuggables (Rust)" },
            },
            settings = {
              ["rust-analyzer"] = {
                cargo = {
                  allFeatures = true,
                  loadOutDirsFromCheck = true,
                  runBuildScripts = true,
                },
                -- Add clippy lints for Rust.
                checkOnSave = {
                  allFeatures = true,
                  command = "clippy",
                  extraArgs = { "--no-deps" },
                },
                procMacro = {
                  enable = true,
                  ignored = {
                    ["async-trait"] = { "async_trait" },
                    ["napi-derive"] = { "napi" },
                    ["async-recursion"] = { "async_recursion" },
                  },
                },
              },
            },
          },
          rust_tools = {
            root_dir = function(...)
              return require("lspconfig.util").root_pattern(".git")(...)
            end,
          },
          lua_ls = {
            -- enabled = false,
            single_file_support = true,
            settings = {
              Lua = {
                workspace = {
                  checkThirdParty = false,
                },
                completion = {
                  workspaceWord = true,
                  callSnippet = "Both",
                },
                misc = {
                  parameters = {
                    -- "--log-level=trace",
                  },
                },
                hint = {
                  enable = true,
                  setType = false,
                  paramType = true,
                  paramName = "Disable",
                  semicolon = "Disable",
                  arrayIndex = "Disable",
                },
                doc = {
                  privateName = { "^_" },
                },
                type = {
                  castNumberToInteger = true,
                },
                diagnostics = {
                  disable = { "incomplete-signature-doc", "trailing-space" },
                  -- enable = false,
                  groupSeverity = {
                    strong = "Warning",
                    strict = "Warning",
                  },
                  groupFileStatus = {
                    ["ambiguity"] = "Opened",
                    ["await"] = "Opened",
                    ["codestyle"] = "None",
                    ["duplicate"] = "Opened",
                    ["global"] = "Opened",
                    ["luadoc"] = "Opened",
                    ["redefined"] = "Opened",
                    ["strict"] = "Opened",
                    ["strong"] = "Opened",
                    ["type-check"] = "Opened",
                    ["unbalanced"] = "Opened",
                    ["unused"] = "Opened",
                  },
                  unusedLocalExclude = { "_*" },
                },
                format = {
                  enable = false,
                  defaultConfig = {
                    indent_style = "space",
                    indent_size = "2",
                    continuation_indent_size = "2",
                  },
                },
              },
            },
          },
        },
        setup = {
          rust_analyzer = function(_, opts)
            local rust_tools_opts = require("lazyvim.util").opts("rust-tools.nvim")
            require("rust-tools").setup(vim.tbl_deep_extend("force", rust_tools_opts or {}, { server = opts }))
            return true
          end,
        },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Ensure mason installs the server
        rust_analyzer = {
          keys = {
            { "K", "<cmd>RustHoverActions<cr>", desc = "Hover Actions (Rust)" },
            { "<leader>cR", "<cmd>RustCodeAction<cr>", desc = "Code Action (Rust)" },
            { "<leader>dr", "<cmd>RustDebuggables<cr>", desc = "Run Debuggables (Rust)" },
          },
          settings = {
            ["rust-analyzer"] = {
              cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
                runBuildScripts = true,
              },
              -- Add clippy lints for Rust.
              checkOnSave = {
                allFeatures = true,
                command = "clippy",
                extraArgs = { "--no-deps" },
              },
              procMacro = {
                enable = false,
                ignored = {
                  ["async-trait"] = { "async_trait" },
                  ["napi-derive"] = { "napi" },
                  ["async-recursion"] = { "async_recursion" },
                },
              },
            },
          },
        },
        taplo = {
          keys = {
            {
              "K",
              function()
                if vim.fn.expand("%:t") == "Cargo.toml" and require("crates").popup_available() then
                  require("crates").show_popup()
                else
                  vim.lsp.buf.hover()
                end
              end,
              desc = "Show Crate Documentation",
            },
          },
        },
      },
      setup = {
        rust_analyzer = function(_, opts)
          local rust_tools_opts = require("lazyvim.util").opts("rust-tools.nvim")
          require("rust-tools").setup(vim.tbl_deep_extend("force", rust_tools_opts or {}, { server = opts }))
          return true
        end,
      },
    },
  },
}
