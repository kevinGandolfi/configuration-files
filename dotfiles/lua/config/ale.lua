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

    -- Configuration des linters par type de fichier
    vim.g.ale_linters = {
        javascript = { 'eslint' },
        java = { 'checkstyle', 'javac', 'pmd' }
    }

    -- Configuration des fixers
    vim.g.ale_fixers = {
        java = { 'google_java_format' },
        ['*'] = { 'remove_trailing_lines', 'trim_whitespace' }
    }

    -- Configuration Java spécifique
    vim.g.ale_java_javac_classpath = '.'
    vim.g.ale_java_javac_options = '-Xlint:all -encoding UTF-8'

    -- Configuration Checkstyle - essayer différentes configurations
    local checkstyle_configs = {
        vim.fn.expand('~/.config/simple_checkstyle.xml'),
        vim.fn.expand('~/.config/google_checks.xml'),
        '/google_checks.xml'
    }

    local checkstyle_config_found = false
    for _, config in ipairs(checkstyle_configs) do
        if vim.fn.filereadable(config) == 1 then
            vim.g.ale_java_checkstyle_config = config
            vim.g.ale_java_checkstyle_options = '-c ' .. config
            checkstyle_config_found = true
            break
        end
    end

    if not checkstyle_config_found then
        -- Configuration par défaut sans fichier
        vim.g.ale_java_checkstyle_options = ''
    end

    -- Configuration PMD - utiliser le wrapper pour la compatibilité
    vim.g.ale_java_pmd_executable = 'pmd-ale'
    vim.g.ale_java_pmd_options = '-R category/java/bestpractices.xml -f text'

    -- Configuration Google Java Format
    vim.g.ale_java_google_java_format_executable = 'google-java-format'
    vim.g.ale_java_google_java_format_options = '--aosp --skip-sorting-imports'

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
    keymap('n', '<leader>al', '<cmd>ALELint<cr>', { desc = 'ALE Lint' })

    -- Auto-détection des projets Java
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "java",
        callback = function()
            M.setup_java_project()
            -- S'assurer que les fixers sont bien configurés pour ce buffer
            vim.b.ale_fixers = { 'google_java_format' }
            -- Forcer le linting au chargement du fichier
            vim.cmd('ALELint')
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
                print("JDTLS détecté - javac désactivé dans ALE")
            end
        end,
    })

    -- Commande pour vérifier la configuration
    vim.api.nvim_create_user_command('ALECheckJavaTools', function()
        M.check_java_tools()
    end, {})
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
        print("Projet Maven détecté")
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
        print("Projet Gradle détecté")
    end
end

-- Fonction pour vérifier les outils Java
function M.check_java_tools()
    local tools = {
        { name = 'javac', cmd = 'javac -version' },
        { name = 'checkstyle', cmd = 'checkstyle --version' },
        { name = 'pmd', cmd = 'pmd --version' },
        { name = 'google-java-format', cmd = 'google-java-format --version' }
    }

    print("=== Vérification des outils Java ===")
    for _, tool in ipairs(tools) do
        local result = vim.fn.system(tool.cmd)
        if vim.v.shell_error == 0 then
            print("✓ " .. tool.name .. " : OK")
        else
            print("✗ " .. tool.name .. " : NON TROUVÉ")
            print("  Commande testée : " .. tool.cmd)
        end
    end

    -- Test des configurations spécifiques
    print("\n=== Test des configurations ===")

    -- Test Checkstyle
    local checkstyle_test = vim.fn.system('checkstyle -c /google_checks.xml --help')
    if vim.v.shell_error == 0 then
        print("✓ Checkstyle config intégrée : OK")
    else
        print("✗ Checkstyle config intégrée : ERREUR")
    end

    -- Test PMD
    local pmd_test = vim.fn.system('pmd -R category/java/bestpractices.xml --help')
    if vim.v.shell_error == 0 then
        print("✓ PMD ruleset : OK")
    else
        print("✗ PMD ruleset : ERREUR")
        -- Essayer d'autres rulesets
        local alt_rulesets = {
            'rulesets/java/basic.xml',
            'rulesets/java/imports.xml',
            'rulesets/java/unusedcode.xml'
        }
        for _, ruleset in ipairs(alt_rulesets) do
            local alt_test = vim.fn.system('pmd -R ' .. ruleset .. ' --help')
            if vim.v.shell_error == 0 then
                print("✓ PMD ruleset alternatif trouvé : " .. ruleset)
                break
            end
        end
    end

    -- Vérifier le fichier de configuration Checkstyle
    local checkstyle_config = vim.fn.expand('~/.config/google_checks.xml')
    if vim.fn.filereadable(checkstyle_config) == 1 then
        print("✓ Configuration Checkstyle : " .. checkstyle_config)
    else
        print("⚠ Configuration Checkstyle personnalisée manquante : " .. checkstyle_config)
        print("  Utilisation de la configuration intégrée")
    end

    print("\n=== Configuration ALE actuelle ===")
    print("Linters Java : " .. vim.inspect(vim.g.ale_linters.java or {}))
    print("Fixers Java : " .. vim.inspect(vim.g.ale_fixers.java or {}))

    -- Test direct des linters
    print("\n=== Test direct des linters ===")
    local test_file = vim.fn.expand('%:p')
    if test_file and vim.fn.filereadable(test_file) == 1 then
        -- Test Checkstyle
        local checkstyle_cmd = 'checkstyle -c /google_checks.xml "' .. test_file .. '"'
        print("Test Checkstyle : " .. checkstyle_cmd)
        local cs_result = vim.fn.system(checkstyle_cmd)
        print("Sortie Checkstyle : " .. (cs_result or "VIDE"))

        -- Test PMD avec nouvelle syntaxe
        local pmd_cmd = 'pmd check -R category/java/bestpractices.xml -f text -d "' .. test_file .. '"'
        print("Test PMD : " .. pmd_cmd)
        local pmd_result = vim.fn.system(pmd_cmd)
        print("Sortie PMD : " .. (pmd_result or "VIDE"))
        print("Code retour PMD : " .. vim.v.shell_error)
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

    -- Vérifier aussi les chemins standards pour les outils
    local common_bin_paths = {
        '/usr/local/bin',
        '/usr/bin',
        vim.fn.expand('~/.local/bin'),
        '/opt/checkstyle/bin',
        '/opt/pmd/bin'
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
