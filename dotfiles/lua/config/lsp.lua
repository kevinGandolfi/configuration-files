-- lua/config/lsp.lua
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local opts = { buffer = args.buf, noremap = true, silent = true }
        vim.keymap.set("n", "<Leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, { noremap = true, silent = true })
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { noremap = true, silent = true })
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, { noremap = true, silent = true })
        vim.keymap.set('n', '<Leader>d', vim.lsp.buf.type_definition, { noremap = true, silent = true })
        vim.keymap.set('n', '<Leader>lr', vim.lsp.codelens.run, { noremap = true, silent = true })
        vim.keymap.set('n', '<Leader>ca', vim.lsp.buf.code_action, { noremap = true, silent = true })
        vim.keymap.set('v', '<Leader>ca', vim.lsp.buf.code_action, { noremap = true, silent = true })
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { noremap = true, silent = true })
    end,
})
