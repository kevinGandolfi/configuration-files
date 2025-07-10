local jdtls = require('jdtls')

local root_markers = {'.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle'}
local root_dir = require('jdtls.setup').find_root(root_markers)
if not root_dir then return end

local home = os.getenv("HOME")
local workspace_folder = home .. "/.local/share/eclipse/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

local jdtls_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
local jar_pattern = jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"
local launcher_jar = vim.fn.glob(jar_pattern)

local config = {
  cmd = {
    "java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.level=ALL",
    "-Xmx1g",
    "-jar", launcher_jar,
    "-configuration", jdtls_path .. "/config_linux",
    "-data", workspace_folder,
  },
  root_dir = root_dir,
}

jdtls.start_or_attach(config)
