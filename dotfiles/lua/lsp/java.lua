local jdtls = require('jdtls')

-- Configuration des chemins
local home = os.getenv('HOME')
local workspace_path = home .. '/.local/share/eclipse/' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local config_path = home .. '/.local/share/nvim/mason/packages/jdtls/config_linux'
local jar_path = home .. '/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar'

-- Trouver le jar launcher
local jar_patterns = {
    home .. '/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar',
    '/usr/share/java/jdtls/plugins/org.eclipse.equinox.launcher_*.jar',
}

local launcher_jar = nil
for _, pattern in ipairs(jar_patterns) do
    local jars = vim.fn.glob(pattern, 0, 1)
    if #jars > 0 then
        launcher_jar = jars[1]
        break
    end
end

if not launcher_jar then
    vim.notify("JDTLS launcher jar not found. Please install via Mason: :MasonInstall jdtls", vim.log.levels.ERROR)
    return
end

-- Configuration JDTLS
local config = {
    cmd = {
        'java',
        '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        '-Dosgi.bundles.defaultStartLevel=4',
        '-Declipse.product=org.eclipse.jdt.ls.core.product',
        '-Dlog.protocol=true',
        '-Dlog.level=ALL',
        '-javaagent:' .. home .. '/.local/share/nvim/mason/packages/jdtls/lombok.jar',
        '-Xms1g',
        '--add-modules=ALL-SYSTEM',
        '--add-opens', 'java.base/java.util=ALL-UNNAMED',
        '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
        '-jar', launcher_jar,
        '-configuration', config_path,
        '-data', workspace_path,
    },
    root_dir = jdtls.setup.find_root({'.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle'}),
    settings = {
        java = {
            eclipse = {
                downloadSources = true,
            },
            configuration = {
                updateBuildConfiguration = "interactive",
                runtimes = {
                    {
                        name = "JavaSE-11",
                        path = "/usr/lib/jvm/java-11-openjdk-amd64/",
                    },
                    {
                        name = "JavaSE-17",
                        path = "/usr/lib/jvm/java-17-openjdk-amd64/",
                    },
                }
            },
            maven = {
                downloadSources = true,
            },
            implementationsCodeLens = {
                enabled = true,
            },
            referencesCodeLens = {
                enabled = true,
            },
            references = {
                includeDecompiledSources = true,
            },
            format = {
                enabled = true,
                settings = {
                    url = vim.fn.stdpath "config" .. "/lang-servers/intellij-java-google-style.xml",
                    profile = "GoogleStyle",
                },
            },
        },
        signatureHelp = { enabled = true },
        completion = {
            favoriteStaticMembers = {
                "org.hamcrest.MatcherAssert.assertThat",
                "org.hamcrest.Matchers.*",
                "org.hamcrest.CoreMatchers.*",
                "org.junit.jupiter.api.Assertions.*",
                "java.util.Objects.requireNonNull",
                "java.util.Objects.requireNonNullElse",
                "org.mockito.Mockito.*",
            },
            importOrder = {
                "java",
                "javax",
                "com",
                "org"
            },
        },
        extendedClientCapabilities = jdtls.extendedClientCapabilities,
        sources = {
            organizeImports = {
                starThreshold = 9999,
                staticStarThreshold = 9999,
            },
        },
        codeGeneration = {
            toString = {
                template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
            },
            useBlocks = true,
        },
    },
    flags = {
        allow_incremental_sync = true,
    },
    init_options = {
        bundles = {}
    },
    on_attach = function(client, bufnr)
        -- Keymaps spécifiques à Java
        local opts = { noremap = true, silent = true, buffer = bufnr }

        -- Navigation
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)

        -- Actions
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('v', '<leader>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format({ async = true }) end, opts)

        -- JDTLS spécifique
        vim.keymap.set('n', '<leader>co', jdtls.organize_imports, opts)
        vim.keymap.set('n', '<leader>crv', jdtls.extract_variable, opts)
        vim.keymap.set('n', '<leader>crc', jdtls.extract_constant, opts)
        vim.keymap.set('v', '<leader>crm', [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]], opts)
        vim.keymap.set('n', '<leader>crm', jdtls.extract_method, opts)

        -- Tests
        vim.keymap.set('n', '<leader>tc', jdtls.test_class, opts)
        vim.keymap.set('n', '<leader>tm', jdtls.test_nearest_method, opts)

        -- Configuration du debugging
        jdtls.setup_dap({ hotcodereplace = 'auto' })

        print("JDTLS attaché au buffer " .. bufnr)
    end,
}

-- Configuration des bundles pour le debugging
local bundles = {}

-- Java Debug Adapter
local java_debug_path = home .. '/.local/share/nvim/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar'
local java_debug_jar = vim.fn.glob(java_debug_path)
if java_debug_jar ~= '' then
    table.insert(bundles, java_debug_jar)
end

-- Java Test Runner
local java_test_path = home .. '/.local/share/nvim/mason/packages/java-test/extension/server/*.jar'
local java_test_jars = vim.fn.glob(java_test_path, 0, 1)
for _, jar in ipairs(java_test_jars) do
    table.insert(bundles, jar)
end

if #bundles > 0 then
    config.init_options.bundles = bundles
end

-- Démarrer JDTLS
jdtls.start_or_attach(config)
