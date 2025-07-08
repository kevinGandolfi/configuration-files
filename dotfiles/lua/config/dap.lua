local dap = require('dap')
local dapui = require('dapui')

-- Configuration DAP UI
dapui.setup({
    layouts = {
        {
            elements = {
                { id = "scopes", size = 0.25 },
                { id = "breakpoints", size = 0.25 },
                { id = "stacks", size = 0.25 },
                { id = "watches", size = 0.25 },
            },
            size = 40,
            position = "left",
        },
        {
            elements = {
                { id = "repl", size = 0.5 },
                { id = "console", size = 0.5 },
            },
            size = 0.25,
            position = "bottom",
        },
    },
    controls = {
        enabled = true,
        element = "repl",
        icons = {
            pause = "",
            play = "",
            step_into = "",
            step_over = "",
            step_out = "",
            step_back = "",
            run_last = "",
            terminate = "",
        },
    },
    floating = {
        max_height = nil,
        max_width = nil,
        border = "single",
        mappings = {
            close = { "q", "<Esc>" },
        },
    },
    windows = { indent = 1 },
    render = {
        max_type_length = nil,
        max_value_lines = 100,
    },
})

-- Configuration DAP Virtual Text
require('nvim-dap-virtual-text').setup({
    enabled = true,
    enabled_commands = true,
    highlight_changed_variables = true,
    highlight_new_as_changed = false,
    show_stop_reason = true,
    commented = false,
    only_first_definition = true,
    all_references = false,
    filter_references_pattern = '<module',
    virt_text_pos = 'eol',
    all_frames = false,
    virt_lines = false,
    virt_text_win_col = nil
})

-- Auto-ouverture/fermeture de DAP UI
dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end

dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end

dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
end

-- Configuration pour le debugging distant (Docker)
dap.configurations.java = {
    {
        type = 'java',
        request = 'attach',
        name = "Debug (Attach) - Remote",
        hostName = "127.0.0.1",
        port = 5005,
    },
    {
        type = 'java',
        request = 'attach',
        name = "Debug (Attach) - Docker",
        hostName = function()
            return vim.fn.input('Host: ', '172.17.0.2')
        end,
        port = function()
            return tonumber(vim.fn.input('Port: ', '5005'))
        end,
    },
}

-- Keymaps supplémentaires pour DAP UI
vim.keymap.set("n", "<leader>du", function() dapui.toggle() end, { desc = "Toggle DAP UI" })
vim.keymap.set("n", "<leader>dr", function() dap.repl.toggle() end, { desc = "Toggle DAP REPL" })
vim.keymap.set("n", "<leader>dk", function() dapui.eval() end, { desc = "Eval under cursor" })
vim.keymap.set("v", "<leader>dk", function() dapui.eval() end, { desc = "Eval selection" })
