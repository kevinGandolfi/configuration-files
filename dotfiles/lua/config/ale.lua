-- lua/config/ale.lua

local M = {}

function M.setup()
    -- Détection automatique des chemins Ubuntu
    M.detect_ubuntu_paths()

    -- Configuration globale ALE
    vim.g.ale_completion_enabled = 0
    vim.g.ale_lint_on_text_changed = 'always'
    vim.g.ale_lint_on_insert_leave = 1
    vim.g.ale_lint_on_enter = 1
    vim.g.ale_lint_on_save = 1
    vim.g.ale_fix_on_save = 1
    vim.g.ale_linters = {
        javascript = { 'eslint' },
        java = { 'checkstyle', 'javac', 'pmd' }
    }

    vim.g.ale_fixers = {
        java = { 'google_java_format' },
        ['*'] = { 'remove_trailing_lines', 'trim_whitespace' }
    }

    vim.g.ale_java_javac_classpath = '.'
    vim.g.ale_java_javac_options = '-Xlint:all -encoding UTF-8'
    vim.g.ale_java_checkstyle_options = '-c ~/.config/google_checks.xml -x "Indentation"'
    vim.g.ale_java_google_java_format_options = '--aosp'

    -- Apparence
    vim.g.ale_echo_msg_format = '[%linter%] %s [%severity%]'
    vim.g.ale_sign_error = '✘'
    vim.g.ale_sign_warning = '⚠'
    vim.g.ale_sign_info = 'ℹ'

    -- Couleurs
    vim.api.nvim_set_hl(0, 'ALEError', { fg = '#ff6b6b', undercurl = true })
    vim.api.nvim_set_hl(0, 'ALEWarning', { fg = '#feca57', undercurl = true })
    vim.api.nvim_set_hl(0, 'ALEInfo', { fg = '#48cae4', undercurl = true })

    -- Raccourcis clavier
    local keymap = vim.keymap.set
    keymap('n', '<leader>ad', '<cmd>ALEDetail<cr>', { desc = 'ALE Error Detail' })
    keymap('n', '<leader>af', '<cmd>ALEFix<cr>', { desc = 'ALE Fix' })
    keymap('n', '<leader>at', '<cmd>ALEToggle<cr>', { desc = 'ALE Toggle' })
    keymap('n', '<leader>ar', '<cmd>ALEReset<cr>', { desc = 'ALE Reset' })
    keymap('n', '<leader>ai', '<cmd>ALEInfo<cr>', { desc = 'ALE Info' })

    -- Auto-détection des projets Java
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "java",
        callback = function()
            M.setup_java_project()
            -- S'assurer que les fixers sont bien configurés pour ce buffer
            vim.b.ale_fixers = { 'google_java_format' }
        end,
    })

    -- Éviter les conflits avec nvim-jdtls
    vim.api.nvim_create_autocmd("LspAttach", {
        pattern = "*.java",
        callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if client and client.name == 'jdtls' then
                -- Désactiver javac d'ALE si JDTLS est actif
                vim.b.ale_linters = { 'checkstyle', 'pmd' }
            end
        end,
    })
end

function M.setup_java_project()
    local cwd = vim.fn.getcwd()

    -- Configuration Maven
    if vim.fn.filereadable(cwd .. '/pom.xml') == 1 then
        local maven_classpath = table.concat({
            cwd .. '/target/classes',
            cwd .. '/target/test-classes',
            cwd .. '/src/main/java',
            cwd .. '/src/test/java'
        }, ':')
        vim.g.ale_java_javac_classpath = maven_classpath
    end

    -- Configuration Gradle
    if vim.fn.filereadable(cwd .. '/build.gradle') == 1 or
       vim.fn.filereadable(cwd .. '/build.gradle.kts') == 1 then
        local gradle_classpath = table.concat({
            cwd .. '/build/classes/java/main',
            cwd .. '/build/classes/java/test',
            cwd .. '/src/main/java',
            cwd .. '/src/test/java'
        }, ':')
        vim.g.ale_java_javac_classpath = gradle_classpath
    end
end

-- Détection automatique des chemins Ubuntu (améliorée)
function M.detect_ubuntu_paths()
    local ubuntu_java_paths = {
        '/usr/lib/jvm/default-java/bin',
        '/usr/lib/jvm/java-11-openjdk-amd64/bin',
        '/usr/lib/jvm/java-17-openjdk-amd64/bin',
        '/usr/lib/jvm/java-21-openjdk-amd64/bin'
    }

    -- Ajouter les chemins Java au PATH
    for _, path in ipairs(ubuntu_java_paths) do
        if vim.fn.isdirectory(path) == 1 then
            local current_path = vim.env.PATH or ""
            if not current_path:find(path, 1, true) then
                vim.env.PATH = path .. ':' .. current_path
            end
        end
    end

    -- Vérifier aussi les chemins standards pour google-java-format
    local common_bin_paths = {
        '/usr/local/bin',
        '/usr/bin',
        vim.fn.expand('~/.local/bin')
    }

    for _, path in ipairs(common_bin_paths) do
        if vim.fn.isdirectory(path) == 1 then
            local current_path = vim.env.PATH or ""
            if not current_path:find(path, 1, true) then
                vim.env.PATH = path .. ':' .. current_path
            end
        end
    end
end
return M
