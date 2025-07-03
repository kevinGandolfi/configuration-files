-- lua/config/lsp.lua

-- Set LSP-related keymaps when an LSP attaches to a buffer
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local opts = { buffer = args.buf, noremap = true, silent = true }
        vim.keymap.set("n", "<Leader>r", vim.lsp.buf.rename, opts)
        vim.keymap.set('n', '<Leader>f', vim.lsp.buf.references, { noremap = true, silent = true })
        vim.keymap.set('n', '<Leader>a', vim.lsp.buf.code_action, { noremap = true, silent = true })
        vim.keymap.set('v', '<Leader>a', vim.lsp.buf.code_action, { noremap = true, silent = true })
        -- Add other LSP-specific keymaps here if needed
    end,
})
