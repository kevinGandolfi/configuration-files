local M = {}

function M.setup()
  M.detect_ubuntu_paths()

  -- Configuration globale ALE
  vim.g.ale_completion_enabled = 0
  vim.g.ale_lint_on_text_changed = 'always'
  vim.g.ale_lint_on_insert_leave = 1
  vim.g.ale_lint_on_enter = 1
  vim.g.ale_lint_on_save = 1
  vim.g.ale_fix_on_save = 1

  -- Linters
  vim.g.ale_linters = {
    javascript = { 'eslint' },
    java = { 'checkstyle', 'javac', 'pmd' },
  }

  -- Fixers
  vim.g.ale_fixers = {
    java = { 'google_java_format' },
    ['*'] = { 'remove_trailing_lines', 'trim_whitespace' },
  }

  -- javac
  vim.g.ale_java_javac_classpath = '.'
  vim.g.ale_java_javac_options = '-Xlint:all -encoding UTF-8'

  -- checkstyle
  vim.g.ale_java_checkstyle_executable = 'java'
  vim.g.ale_java_checkstyle_options =
    '-jar ' .. vim.fn.expand('~/checkstyle.jar') .. ' -c /google_checks.xml'

  -- google-java-format
  vim.g.ale_java_google_java_format_executable = 'java'
  vim.g.ale_java_google_java_format_options =
    '-jar ' .. vim.fn.expand('~/google-java-format.jar') .. ' --aosp'

  -- PMD (v7)
  vim.g.ale_java_pmd_executable = vim.fn.expand('~/pmd-bin-7.15.0/bin/pmd')
  vim.g.ale_java_pmd_options =
    'check --dir % --rulesets category/java/bestpractices.xml --format text'

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
  local km = vim.keymap.set
  km('n', '<leader>ad', '<cmd>ALEDetail<cr>', { desc = 'ALE Error Detail' })
  km('n', '<leader>af', '<cmd>ALEFix<cr>', { desc = 'ALE Fix' })
  km('n', '<leader>at', '<cmd>ALEToggle<cr>', { desc = 'ALE Toggle' })
  km('n', '<leader>ar', '<cmd>ALEReset<cr>', { desc = 'ALE Reset' })
  km('n', '<leader>ai', '<cmd>ALEInfo<cr>', { desc = 'ALE Info' })
  km('n', '<leader>al', '<cmd>ALELint<cr>', { desc = 'ALE Lint' })

  -- Projet Java : Maven / Gradle
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'java',
    callback = function()
      M.setup_java_project()
      vim.b.ale_fixers = { 'google_java_format' }
      vim.cmd('ALELint')
    end,
  })

  -- Commande utilitaire
  vim.api.nvim_create_user_command('ALECheckJavaTools', function()
    M.check_java_tools()
  end, {})
end

function M.setup_java_project()
  local cwd = vim.fn.getcwd()

  if vim.fn.filereadable(cwd .. '/pom.xml') == 1 then
    vim.g.ale_java_javac_classpath = table.concat({
      cwd .. '/target/classes',
      cwd .. '/target/test-classes',
      cwd .. '/src/main/java',
      cwd .. '/src/test/java',
    }, ':')
    print('Projet Maven détecté')
  elseif
    vim.fn.filereadable(cwd .. '/build.gradle') == 1
    or vim.fn.filereadable(cwd .. '/build.gradle.kts') == 1
  then
    vim.g.ale_java_javac_classpath = table.concat({
      cwd .. '/build/classes/java/main',
      cwd .. '/build/classes/java/test',
      cwd .. '/src/main/java',
      cwd .. '/src/test/java',
    }, ':')
    print('Projet Gradle détecté')
  end
end

function M.detect_ubuntu_paths()
  local java_paths = {
    '/usr/lib/jvm/default-java/bin',
    '/usr/lib/jvm/java-11-openjdk-amd64/bin',
    '/usr/lib/jvm/java-17-openjdk-amd64/bin',
    '/usr/lib/jvm/java-21-openjdk-amd64/bin',
  }

  for _, path in ipairs(java_paths) do
    if vim.fn.isdirectory(path) == 1 then
      local current_path = vim.env.PATH or ''
      if not current_path:find(path, 1, true) then
        vim.env.PATH = path .. ':' .. current_path
      end
    end
  end

  local bin_paths = {
    '/usr/local/bin',
    '/usr/bin',
    vim.fn.expand('~/.local/bin'),
    '/opt/checkstyle/bin',
    '/opt/pmd/bin',
  }

  for _, path in ipairs(bin_paths) do
    if vim.fn.isdirectory(path) == 1 then
      local current_path = vim.env.PATH or ''
      if not current_path:find(path, 1, true) then
        vim.env.PATH = path .. ':' .. current_path
      end
    end
  end
end

return M
