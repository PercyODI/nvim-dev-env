return { -- Theming and colors
{
    'navarasu/onedark.nvim',
    config = function()
        require('onedark').load()
    end
}, -- Utilities
'nvim-lua/plenary.nvim', {
    'smoka7/hop.nvim',
    tag = "*",
    config = function()
        require('hop').setup {
            keys = 'etovxqpdygfblzhckisuran'
        }
    end
}, {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
        bigfile = {
            enabled = true
        },
        dashboard = {
            enabled = true
        },
        explorer = {
            enabled = true
        },
        indent = {
            enabled = true
        },
        input = {
            enabled = true
        },
        picker = {
            enabled = true
        },
        notifier = {
            enabled = true
        },
        quickfile = {
            enabled = true
        },
        scope = {
            enabled = true
        },
        scroll = {
            enabled = true
        },
        statuscolumn = {
            enabled = true
        },
        words = {
            enabled = true
        }
    }
}, {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = {"BufReadPost", "BufNewFile"},
    dependencies = {'nvim-treesitter/nvim-treesitter-textobjects' -- for advanced motions and selections
    },
    config = function()
        require('nvim-treesitter.configs').setup({
            ensure_installed = {"bash", "c", "cpp", "css", "html", "java", "javascript", "json", "lua", "markdown",
                                "markdown_inline", "python", "regex", "typescript", "yaml"},
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false
            },
            indent = {
                enable = true
            },
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true, -- Automatically jump forward to textobj
                    keymaps = {
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                        ["ac"] = "@class.outer",
                        ["ic"] = "@class.inner"
                    }
                },
                move = {
                    enable = true,
                    set_jumps = true, -- whether to set jumps in the jumplist
                    goto_next_start = {
                        ["]m"] = "@function.outer",
                        ["]]"] = "@class.outer"
                    },
                    goto_previous_start = {
                        ["[m"] = "@function.outer",
                        ["[["] = "@class.outer"
                    }
                }
            }
        })
    end
}, {
    "ojroques/nvim-osc52",
    config = function()
        require("osc52").setup {}
        vim.api.nvim_create_autocmd("TextYankPost", {
            callback = function()
                if vim.v.event.operator == "y" and vim.v.event.regname == "" then
                    require("osc52").copy_register("")
                end
            end
        })
    end
}, -- Completion 
{
    'hrsh7th/nvim-cmp',
    dependencies = {'hrsh7th/cmp-nvim-lsp', 'hrsh7th/cmp-buffer', 'hrsh7th/cmp-path', 'hrsh7th/cmp-cmdline',
                    'saadparwaiz1/cmp_luasnip', 'L3MON4D3/LuaSnip', 'rafamadriz/friendly-snippets',
                    'onsails/lspkind.nvim'},
    config = function()
        local cmp = require('cmp')
        local luasnip = require('luasnip')

        require("luasnip.loaders.from_vscode").lazy_load()

        cmp.setup({
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<CR>'] = cmp.mapping.confirm({
                    select = true
                }),
                ['<Tab>'] = cmp.mapping.confirm({
                    select = true
                }),
                ['<S-Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, {"i", "s"})
            }),
            sources = cmp.config.sources({ -- { name = 'copilot' },
            {
                name = 'nvim_lsp'
            }, {
                name = 'luasnip'
            }}, {{
                name = 'buffer'
            }, {
                name = 'path'
            }}),
            formatting = {
                format = require("lspkind").cmp_format({
                    mode = 'symbol_text',
                    maxwidth = 50,
                    ellipsis_char = '...'
                })
            }
        })

        -- Optional: Cmdline completions
        cmp.setup.cmdline({'/', '?'}, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {{
                name = 'buffer'
            }}
        })

        cmp.setup.cmdline(':', {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({{
                name = 'path'
            }}, {{
                name = 'cmdline'
            }})
        })
    end
}, {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
        local npairs = require("nvim-autopairs")
        npairs.setup({
            check_ts = true -- enable Treesitter integration for better pairing
        })

        -- Integration with nvim-cmp
        local cmp = require("cmp")
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end
}, -- -- GitHub Copilot + CMP integration
-- {
--   "zbirenbaum/copilot.lua",
--   cmd = "Copilot",
--   build = ":Copilot auth",
--   event = "InsertEnter",
--   config = function()
--     require("copilot").setup({
--       suggestion = { enabled = false }, -- disable inline suggestions
--       panel = { enabled = false }, -- disable right panel
--     })
--   end,
-- },
-- {
--   "zbirenbaum/copilot-cmp",
--   dependencies = { "copilot.lua" },
--   config = function()
--     require("copilot_cmp").setup()
--   end
-- },
-- Language Specific Plugins
{
    'williamboman/mason.nvim',
    build = ':MasonUpdate',
    config = function()
        require('mason').setup()
    end
}, {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {'b0o/schemastore.nvim'},
    config = function()
        require("mason-lspconfig").setup({
            ensure_installed = {"lua_ls", "jdtls", "pyright", "ts_ls", "jsonls", "ltex"}
        })
    end
}, 'nvim-java/nvim-java'}
