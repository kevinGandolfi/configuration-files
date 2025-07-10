vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local opts = { buffer = args.buf, noremap = true, silent = true }
        vim.keymap.set("n", "<Leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<Leader>d", vim.lsp.buf.type_definition, opts)
        vim.keymap.set("n", "<Leader>lr", vim.lsp.codelens.run, opts)
        vim.keymap.set("n", "<Leader>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("v", "<Leader>ca", vim.lsp.buf.code_action, opts)
    end,
})
