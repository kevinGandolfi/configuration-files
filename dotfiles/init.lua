vim.g.mapleader = ","

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git", lazypath
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    { "dense-analysis/ale" },
    { "editorconfig/editorconfig-vim" },
    -- Completion engine
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
        },
    },

    { "junegunn/fzf", build = "./install --bin" },
    { "junegunn/fzf.vim" },
    { "kana/vim-smartword" },
    { 
        "kana/vim-textobj-entire", 
        dependencies = { "kana/vim-textobj-user" }
    },
    { "mfussenegger/nvim-jdtls" },
    { "mhinz/vim-grepper" },
    { "neovim/nvim-lspconfig" },
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
    { "psliwka/vim-smoothie" },
    { "radenling/vim-dispatch-neovim" },
    { "rose-pine/neovim", name = "rose-pine" },
    { "tpope/vim-commentary" },
    { "tpope/vim-dispatch" },
    { "tpope/vim-fugitive" },
    { "tpope/vim-obsession" },
    { "tpope/vim-projectionist" },
    { "tpope/vim-scriptease" },
    { "tpope/vim-surround" },
    { "tpope/vim-unimpaired" },
    { "vim-airline/vim-airline" },
    { "vim-airline/vim-airline-themes" },
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
})

require("nvim-treesitter.configs").setup {
    ensure_installed = { "java", "lua", "json" },
    highlight = { 
        enable = true,
        disable = { "vimdoc" },
    },
    indent = { 
        enable = true, 
        disable = { "vimdoc" },
    },
    auto_install = true,
    ignore_install = { "vimdoc" },
}

require("mason").setup()
require("mason-lspconfig").setup()
require("config.lsp")
require("config.options")
require("config.keymaps")
require("config.cmp")
require('config.ale').setup()

-- Java specific LSP
vim.api.nvim_create_autocmd("FileType", {
    pattern = "java",
    callback = function()
        require("java_lsp")  -- You’ll need to define lua/java_lsp.lua
    end,
})

vim.cmd.colorscheme("rose-pine")
