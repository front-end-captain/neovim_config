-- 从文件路径向上查找最近的 node_modules/typescript/lib
local function find_tsdk(path)
  local function search(dir)
    local tsdk = dir .. "/node_modules/typescript/lib"
    if vim.uv.fs_stat(tsdk) then
      return tsdk
    end
    local parent = vim.fn.fnamemodify(dir, ":h")
    if parent == dir then return nil end
    return search(parent)
  end
  return search(path)
end

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        vtsls = {
          -- explicitly add default filetypes, so that we can extend
          -- them in related extras
          filetypes = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
          },
          init_options = {
            hostInfo = "neovim",
            preferences = {
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = true,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
              disableSuggestions = true,
            },
          },
          settings = {
            complete_function_calls = true,
            vtsls = {
              enableMoveToFileCodeAction = true,
              autoUseWorkspaceTsdk = false,
              experimental = {
                maxInlayHintLength = 30,
                completion = {
                  enableServerSideFuzzyMatch = true,
                },
              },
            },
            typescript = {
              tsdk = "",  -- 由 before_init 动态填入
              updateImportsOnFileMove = { enabled = "always" },
              suggest = {
                completeFunctionCalls = true,
              },
              inlayHints = {
                enumMemberValues = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                parameterNames = { enabled = "all" },
                parameterTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                variableTypes = { enabled = false },
              },
            },
          },
          before_init = function(params, config)
            -- params.rootPath 是 LSP 协议传来的项目根目录
            local tsdk = find_tsdk(params.rootPath or vim.fn.getcwd())
            if tsdk then
              config.settings.typescript.tsdk = tsdk
            end
          end,
        },
        eslint = {
          -- nodePath = local_config_loaded and local_config.eslint.nodePath or "node_modules",
          nodePath = "node_modules",
          workingDirectories = { mode = "auto" },
          format = false,
        },
      },
    },
  },
}
