local java = require("java")

java.setup({
  jdk = {
    auto_install = true,
  },
  dap = {
    hotcodereplace = "auto",
  },
})
