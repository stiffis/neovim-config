---@type LazySpec
return {
  {
    "nvim-java/nvim-java",
    init = function()
      local mason = vim.fn.stdpath "data" .. "/mason"
      local lombok = mason .. "/share/jdtls/lombok.jar"
      local javaagent = "-javaagent:" .. lombok
      local current = vim.env.JDTLS_JVM_ARGS or ""

      if not current:match(vim.pesc(javaagent)) then
        vim.env.JDTLS_JVM_ARGS = current ~= "" and (current .. " " .. javaagent) or javaagent
      end
    end,
    ft = { "java" },
    commit = "61e18c47dcf237e29c9689201bf13c0708c288bc",
    pin = true,
    config = false,
    dependencies = {
      {
        "neovim/nvim-lspconfig",
        opts = {
          servers = {
            jdtls = {
              handlers = {
                ["$/progress"] = function() end,
              },
            },
          },
          setup = {
            jdtls = function()
              require("java").setup {
                root_markers = {
                  "settings.gradle",
                  "settings.gradle.kts",
                  "pom.xml",
                  "build.gradle",
                  "build.gradle.kts",
                  "mvnw",
                  "gradlew",
                },
                jdk = {
                  auto_install = false,
                },
                spring_boot_tools = {
                  enable = true,
                  version = "1.55.1",
                },
                java_test = {
                  enable = true,
                  version = "0.43.2",
                },
                java_debug_adapter = {
                  enable = true,
                  version = "0.58.3",
                },
              }
            end,
          },
        },
      },
      {
        "mfussenegger/nvim-dap",
      },
    },
  },
}
