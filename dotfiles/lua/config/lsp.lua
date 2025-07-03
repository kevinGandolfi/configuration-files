-- lua/config/lsp.lua
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local opts = { buffer = args.buf, noremap = true, silent = true }
        vim.keymap.set("n", "<Leader>r", vim.lsp.buf.rename, opts)
        vim.keymap.set('n', '<Leader>f', vim.lsp.buf.references, { noremap = true, silent = true })
        vim.keymap.set('n', '<Leader>a', vim.lsp.buf.code_action, { noremap = true, silent = true })
        vim.keymap.set('v', '<Leader>a', vim.lsp.buf.code_action, { noremap = true, silent = true })
    end,
})
