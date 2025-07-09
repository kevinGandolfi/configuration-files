vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")

-- Grepper
vim.keymap.set("n", "<Leader>G", ":Grepper -tool rg<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>g", ":Grepper -tool git<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>f", ":Grepper -cword -noprompt<CR>", { noremap = true, silent = true })

-- Ale
vim.keymap.set("n", "<Leader>l", ":ALELint<CR>", { noremap = true, silent = true })
vim.keymap.set('n', '[W', '<Plug>(ale_first)', { silent = true })
vim.keymap.set('n', '[w', '<Plug>(ale_previous)', { silent = true })
vim.keymap.set('n', ']W', '<Plug>(ale_last)', { silent = true })
vim.keymap.set('n', ']w', '<Plug>(ale_next)', { silent = true })
vim.keymap.set("n", "<C-l>", "<Cmd>nohlsearch<CR><C-l>", { noremap = true, silent = true })

-- FZF
vim.keymap.set("n", "<C-p>", ":FZF<CR>", { noremap = true })

-- Smartword
vim.keymap.set("n", "w", "<Plug>(smartword-w)")
vim.keymap.set("n", "b", "<Plug>(smartword-b)")
vim.keymap.set("n", "e", "<Plug>(smartword-e)")
vim.keymap.set("n", "ge", "<Plug>(smartword-ge)")

-- VimSmoothie
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

vim.keymap.set("n", "<F5>", function() require'dap'.continue() end)
vim.keymap.set("n", "<F10>", function() require'dap'.step_over() end)
vim.keymap.set("n", "<F11>", function() require'dap'.step_into() end)
vim.keymap.set("n", "<F12>", function() require'dap'.step_out() end)
vim.keymap.set("n", "<Leader>b", function() require'dap'.toggle_breakpoint() end)
vim.keymap.set("n", "<leader>dl", function()
  vim.cmd("edit ~/.cache/nvim/dap.log")
end, { desc = "Ouvrir les logs DAP" })
vim.keymap.set("n", "<Leader>do", function()
      require("dapui").open()
end, { desc = "dapui.open" })
vim.keymap.set("n", "<Leader>B", function()
  require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "dap.set_breakpoint with condition" })
vim.keymap.set("n", "<Leader>dq", function()
  require("dapui").close()
end, { desc = "dapui.close" })

vim.keymap.set({ "n", "v" }, "<Leader>dh", function()
  require("dap.ui.widgets").hover()
end, { desc = "dap.ui.widgets.hover" })

vim.keymap.set({ "n", "v" }, "<Leader>dp", function()
  require("dap.ui.widgets").preview()
end, { desc = "dap.ui.widgets.preview" })

vim.keymap.set("n", "<Leader>df", function()
  local widgets = require("dap.ui.widgets")
  widgets.centered_float(widgets.frames)
end, { desc = "dap.ui.widgets.frames" })

vim.keymap.set("n", "<Leader>dsc", function()
  local widgets = require("dap.ui.widgets")
  widgets.centered_float(widgets.scopes)
end, { desc = "dap.ui.widgets.scopes" })
