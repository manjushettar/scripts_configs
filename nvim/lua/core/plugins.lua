local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
    {
        'wakatime/vim-wakatime',
        lazy=false
    },
    {
    "melbaldove/llm.nvim",
    dependencies = { "nvim-neotest/nvim-nio" },
    config = function()
        require("llm").setup({
            timeout_ms = 10,
            services = {
                anthropic = {
                    url = "https://api.anthropic.com/v1/messages",
                    model = "claude-3-5-sonnet-latest",
                    api_key_name = #YOUR API KEY HERE,
                },
            },
        })
    end,
    },
    {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
    },
    config = function()
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "clangd",      -- C/C++
                "ts_ls",    -- TypeScript/JavaScript
                "eslint",      -- ESLint
                "lua_ls",      -- Lua
                "cssls",       -- CSS
                "html",        -- HTML
                "jsonls",      -- JSON
            }
        })

        local lspconfig = require('lspconfig')
        local capabilities = require('cmp_nvim_lsp').default_capabilities()

        -- Common setup for all LSP servers
        local common_setup = {
            capabilities = capabilities,
            flags = {
                debounce_text_changes = 150,
            },
            settings = {
                inlayHints = { enabled = true }
            }
        }
        
        -- TypeScript/JavaScript configuration
        lspconfig.ts_ls.setup(vim.tbl_extend('force', common_setup, {
            settings = {
                typescript = {
                    inlayHints = {
                        includeInlayParameterNameHints = 'all',
                        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                        includeInlayFunctionParameterTypeHints = true,
                        includeInlayVariableTypeHints = true,
                        includeInlayVariableTypeHintsWhenTypeMatchesName = false,
                        includeInlayPropertyDeclarationTypeHints = true,
                        includeInlayFunctionLikeReturnTypeHints = true,
                        includeInlayEnumMemberValueHints = true,
                    }
                },
                javascript = {
                    inlayHints = {
                        includeInlayParameterNameHints = 'all',
                        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                        includeInlayFunctionParameterTypeHints = true,
                        includeInlayVariableTypeHints = true,
                        includeInlayVariableTypeHintsWhenTypeMatchesName = false,
                        includeInlayPropertyDeclarationTypeHints = true,
                        includeInlayFunctionLikeReturnTypeHints = true,
                    }
                }
            }
        }))

        -- ESLint configuration
        lspconfig.eslint.setup(vim.tbl_extend('force', common_setup, {
            on_attach = function(client, bufnr)
                vim.api.nvim_create_autocmd("BufWritePre", {
                    buffer = bufnr,
                    command = "EslintFixAll",
                })
            end,
        }))

        -- Python configuration with Pyright
        lspconfig.pylsp.setup(vim.tbl_extend('force', common_setup, {
                settings = {
                pylsp = {
                    plugins = {
                        pylint = {
                            enabled = true,
                            executable = "pylint"
                        },
                        pycodestyle = {
                            enabled = true,
                            maxLineLength = 100
                        },
                        autopep8 = {
                            enabled = true
                        },
                        yapf = {
                            enabled = false
                        },
                        mccabe = {
                            enabled = true,
                            threshold = 15
                        },
                        preload = {
                            enabled = true
                        },
                        rope_completion = {
                            enabled = true
                        },
                        jedi_completion = {
                            enabled = true,
                            include_params = true
                        },
                        jedi_hover = {
                            enabled = true
                        },
                        jedi_references = {
                            enabled = true
                        },
                        jedi_signature_help = {
                            enabled = true
                        },
                        jedi_symbols = {
                            enabled = true,
                            all_scopes = true
                        }
                    }
                }
            }
        }))

        -- C/C++ configuration with clangd
        lspconfig.clangd.setup(vim.tbl_extend('force', common_setup, {
            cmd = {
                "clangd",
                "--background-index",
                "--suggest-missing-includes",
                "--clang-tidy",
                "--header-insertion=iwyu",
                "--inlay-hints",
                "--completion-style=detailed",
            },
        }))

        -- Lua configuration
        lspconfig.lua_ls.setup(vim.tbl_extend('force', common_setup, {
            settings = {
                Lua = {
                    hint = {
                        enable = true,
                        arrayIndex = "Enable",
                        setType = true,
                        paramName = "All",
                        paramType = true,
                    },
                    diagnostics = {
                        globals = { 'vim' }
                    }
                }
            }
        }))

        -- Diagnostic configuration
        vim.diagnostic.config({
            virtual_text = true,
            signs = true,
            underline = true,
            update_in_insert = false,
            severity_sort = true,
            float = {
                border = 'rounded',
                source = 'always',
                header = '',
                prefix = '',
            },
        })

        -- Sign configuration
        for type, icon in pairs({
            Error = " ",
            Warn = " ",
            Hint = " ",
            Info = " ",
        }) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
        end
    end
},
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
          "hrsh7th/cmp-nvim-lsp",
          "hrsh7th/cmp-buffer",
          "hrsh7th/cmp-path",
          "hrsh7th/cmp-cmdline",
          "hrsh7th/cmp-vsnip",
          "hrsh7th/vim-vsnip",
        },
    },
    {
        "nvim-telescope/telescope.nvim", 
        dependencies = "tsakirist/telescope-lazy.nvim"
    },
    {
        "nvim-lua/plenary.nvim",
    },
    {
        'goolord/alpha-nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            local alpha = require('alpha')
            local dashboard = require('alpha.themes.dashboard')
            dashboard.section.buttons.val = {
                dashboard.button("n", "  New file", ":ene <BAR> startinsert <CR>"),
                dashboard.button("f", "  Find file", ":Files<CR>"),
                dashboard.button("r", "  Recent files", ":History<CR>"),
                dashboard.button("t", "  Find text", ":Rg<CR>"),
                dashboard.button("s", "  Settings", ":e $MYVIMRC <CR>"),
                dashboard.button("u", "  Update plugins", ":Lazy sync<CR>"),
                dashboard.button("q", "  Quit", ":qa<CR>"),
            }

            alpha.setup(dashboard.opts)
        end
    }, 
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            require("catppuccin").setup({
                flavour = "mocha",
                transparent_background = false,
                dim_inactive = {
                    enabled = true,
                    shade = "dark",
                    percentage = 0.15,
                },
                styles = {
                    comments = { "italic" },
                    conditionals = { "italic" },
                    loops = { "italic" },
                    functions = { "italic" },
                    keywords = { "italic" },
                    strings = { "italic" },
                    variables = { "italic" },
                    numbers = { "italic" },
                    booleans = { "italic" },
                    properties = { "italic" },
                    types = { "italic" },
                },
                integrations = {
                    treesitter = true,
                    native_lsp = {
                        enabled = true,
                        virtual_text = {
                            errors = { "italic" },
                            hints = { "italic" },
                            warnings = { "italic" },
                            information = { "italic" },
                        },
                        underlines = {
                            errors = { "underline" },
                            hints = { "underline" },
                            warnings = { "underline" },
                            information = { "underline" },
                        },
                    },
                    cmp = true,
                    gitsigns = true,
                    telescope = true,
                    markdown = true,
                    mason = true,
                }
            })
        end
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = { 
                    "lua", "vim", "vimdoc", "python", "cpp", 
                    "javascript", "typescript", "html", "css" 
                },
                sync_install = false,
                auto_install = true,
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
                indent = { enable = true },
            })
        end
    },
    {
        "vim-airline/vim-airline",
        dependencies = { "vim-airline/vim-airline-themes" },
        config = function()
            vim.g.airline_powerline_fonts = 1
            vim.g.airline_section_b = '%{getcwd()}'
            vim.g.airline_theme = 'catppuccin'
            vim.g['airline#extensions#tabline#enabled'] = 1
            vim.g['airline#extensions#tabline#formatter'] = 'unique_tail'
        end,
    },
    {
        "preservim/nerdtree",
    },
    {
        "iamcco/markdown-preview.nvim",
        build = "cd app && npx --yes yarn install",
        config = function()
            vim.g.mkdp_theme = 'dark'
        end,
    },
    {
        "junegunn/fzf",
        build = function()
            vim.fn["fzf#install"]()
        end,
        dependencies = { "junegunn/fzf.vim" },
    },
})
