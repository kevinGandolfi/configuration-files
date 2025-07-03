vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")
vim.keymap.set("n", "<Leader>G", ":Grepper -tool rg<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>g", ":Grepper -tool git<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>f", ":Grepper -cword -noprompt<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>l", ":ALELint<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<C-l>", "<Cmd>nohlsearch<CR><C-l>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-p>", ":FZF<CR>", { noremap = true })

vim.keymap.set("n", "w", "<Plug>(smartword-w)")
vim.keymap.set("n", "b", "<Plug>(smartword-b)")
vim.keymap.set("n", "e", "<Plug>(smartword-e)")
vim.keymap.set("n", "ge", "<Plug>(smartword-ge)")

vim.keymap.set("n", "<Up>", "<Plug>(SmoothieUpwards)")
vim.keymap.set("n", "<Down>", "<Plug>(SmoothieDownwards)")

-- Window navigation
vim.keymap.set("n", "<M-h>", "<C-w>h")
vim.keymap.set("n", "<M-j>", "<C-w>j")
vim.keymap.set("n", "<M-k>", "<C-w>k")
vim.keymap.set("n", "<M-l>", "<C-w>l")
vim.keymap.set("n", "<M-w>", "<C-w>w")

-- Terminal mode mappings
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.cmd([[
      tnoremap <Esc> <C-\><C-n>
      tnoremap <C-v><Esc> <Esc>
      tnoremap <M-h> <C-\><C-n><C-w>h
      tnoremap <M-j> <C-\><C-n><C-w>j
      tnoremap <M-k> <C-\><C-n><C-w>k
      tnoremap <M-l> <C-\><C-n><C-w>l
      tnoremap <M-w> <C-\><C-n><C-w>w
    ]])
  end
})

