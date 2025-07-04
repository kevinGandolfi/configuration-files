-- lua/config/lsp.lua
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local opts = { buffer = args.buf, noremap = true, silent = true }
        vim.keymap.set("n", "<Leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set('n', '<Leader>rf', vim.lsp.buf.references, { noremap = true, silent = true })
        vim.keymap.set('n', '<Leader>ca', vim.lsp.buf.code_action, { noremap = true, silent = true })
        vim.keymap.set('v', '<Leader>ca', vim.lsp.buf.code_action, { noremap = true, silent = true })
    end,
})
