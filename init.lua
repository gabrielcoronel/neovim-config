-- === General Options ===
-- Disable NetRW
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Tabs
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

-- Line numbers
vim.o.number = true
vim.o.relativenumber = true
vim.o.numberwidth = 5

-- Searching
vim.o.hlsearch = false
vim.o.ignorecase = true
vim.o.wrap = false

-- Other
vim.o.background = "dark"
vim.o.colorcolumn = "80"
vim.o.undofile = true
vim.o.completeopt = "menuone,preview,noinsert"
vim.o.termguicolors = true
vim.o.clipboard = "unnamedplus"
vim.o.scrolloff = 8
vim.cmd.highlight("clear SignColumn")

-- === Package Management ===
-- Bootstrap package manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Install packages
require("lazy").setup({
    {
        -- Autoclose brackets
        "m4xshen/autoclose.nvim",
        config = function()
            require("autoclose").setup()
        end
    },
    {
        -- Gruvbox Colorscheme
        "ellisonleao/gruvbox.nvim",
        config = function()
            require("gruvbox").setup({
                contrast = "hard";
                italic = {
                    strings = false,
                    emphasis = false,
                    comments = false,
                    operators = false,
                    folds = false,
                },
            })

            vim.cmd([[colorscheme gruvbox]])
        end
    },
    {
        -- Status line
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("lualine").setup()
        end
    },
    {
        -- Comment Keybindings
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup()
        end
    },
    {
        -- Treesitter
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function ()
            require("nvim-treesitter.configs").setup({
                highlight = { enable = true },
                indent = { enable = true }
            })
        end
    },
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = {
            "nvim-tree/nvim-web-devicons"
        },
        config = function()
            require("nvim-tree").setup()

            vim.keymap.set({ "n", "v" }, "<leader>f", function()
                vim.cmd([[NvimTreeToggle]])
            end)
        end
    },

    -- LSP Setup
    {
        -- LSP basic configuration
        "neovim/nvim-lspconfig",
        config = function()
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("UserLspConfig", {}),
                callback = function(event)
                    local options = { buffer = event.buf }

                    -- Diagnostics
                    vim.keymap.set("n", "K", vim.lsp.buf.hover, options)
                    vim.keymap.set("n", "gl", vim.diagnostic.open_float)
                    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
                    vim.keymap.set("n", "]d", vim.diagnostic.goto_next)

                    -- References and implementations
                    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, options)
                    vim.keymap.set("n", "gr", vim.lsp.buf.references, options)
                    vim.keymap.set("n", "gd", vim.lsp.buf.definition, options)
                    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, options)

                    -- Actions
                    vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, options)
                    vim.keymap.set("n", "<F3>", vim.lsp.buf.format, options)
                    vim.keymap.set({ "n", "v" }, "<F4>", vim.lsp.buf.code_action, options)
                    -- NOTE: F5 keymap is left for code execution
                end
            })
        end
    },
    {
        -- Completion framework
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            local cmp = require("cmp")

            cmp.setup({
                mapping = cmp.mapping.preset.insert({
                    ["<C-i>"] = cmp.mapping.complete(),
                    ["<CR>"] = cmp.mapping.confirm({ select = false })
                }),
                completion = {
                    autocomplete = false
                }
            })
        end
    },
    {
        -- Snippet framework
        "L3MON4D3/LuaSnip",
        config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
            require("luasnip.loaders.from_snipmate").lazy_load()
        end
    },
    {
        -- External package manager
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end
    },
    {
        -- LSP Zero: Puts everything together
        "VonHeikemen/lsp-zero.nvim",
        dependencies = {
            "williamboman/mason-lspconfig.nvim"
        },
        config = function()
            local lsp_zero = require("lsp-zero")

            require("mason-lspconfig").setup({
                handlers = {
                    lsp_zero.default_setup
                }
            })
        end
    }
})
