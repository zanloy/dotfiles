local keymap = vim.keymap.set
local api = vim.api

---------- LSP Servers ----------
local servers = {
  pyright = {
    settings = {
      python = {
        analysis = {
          typeCheckingMode = "off",
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
          diagnosticMode = "workspace",
        },
      },
    },
  },
  sumneko_lua = {
    settings = {
      Lua = {
        runtime = {
          version = "LuaJIT",
          path = vim.split(package.path, ";"),
        },
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          library = api.nvim_get_runtime_file("", true),
        },
        telemetry = { enable = false },
      },
    },
  },
}
