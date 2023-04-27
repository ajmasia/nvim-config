local null_ls = require("null-ls")

local list_registered_providers_names = function(filetype)
  local s = require("null-ls.sources")
  local available_sources = s.get_available(filetype)
  local registered = {}

  for _, source in ipairs(available_sources) do
    for method in pairs(source.methods) do
      registered[method] = registered[method] or {}
      table.insert(registered[method], source.name)
    end
  end
  return registered
end

local formatters_list_registered = function(filetype, source_method)
  local registered_providers = list_registered_providers_names(filetype)
  return registered_providers[null_ls.methods[source_method]] or {}
end

local alternative_methods = {
  null_ls.methods.DIAGNOSTICS,
  null_ls.methods.DIAGNOSTICS_ON_OPEN,
  null_ls.methods.DIAGNOSTICS_ON_SAVE,
}

local alternative_methods_list_registered = function(filetype)
  local registered_providers = list_registered_providers_names(filetype)
  local providers_for_methods = vim.tbl_flatten(vim.tbl_map(function(m)
    return registered_providers[m] or {}
  end, alternative_methods))

  return providers_for_methods
end

return {
  {
    -- {
    --   "jonahgoldwastaken/copilot-status.nvim",
    --   dependencies = { "zbirenbaum/copilot.lua" }, -- or "copilot.lua"
    --   lazy = true,
    --   event = "BufReadPost",
    -- },
    {
      "nvim-lualine/lualine.nvim",
      event = "VeryLazy",
      opts = function()
        local icons = require("lazyvim.config").icons
        local Util = require("lazyvim.util")

        return {
          options = {
            theme = "auto",
            globalstatus = true,
            disabled_filetypes = { statusline = { "dashboard", "alpha" } },
            component_separators = { left = "", right = "" },
            section_separators = { left = "", right = "" },
          },
          sections = {
            lualine_a = { "mode" },
            lualine_b = { "branch" },
            lualine_c = {
              {
                "diagnostics",
                symbols = {
                  error = icons.diagnostics.Error,
                  warn = icons.diagnostics.Warn,
                  info = icons.diagnostics.Info,
                  hint = icons.diagnostics.Hint,
                },
              },
              { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
              { "filename", path = 1, symbols = { modified = "  ", readonly = "", unnamed = "" } },
              {
                function()
                  return require("nvim-navic").get_location()
                end,
                cond = function()
                  return package.loaded["nvim-navic"] and require("nvim-navic").is_available()
                end,
              },
            },
            lualine_x = {
              {
                function()
                  return require("noice").api.status.mode.get()
                end,
                cond = function()
                  return package.loaded["noice"] and require("noice").api.status.mode.has()
                end,
                color = Util.fg("Constant"),
              },
              {
                function()
                  return "  " .. require("dap").status()
                end,
                cond = function()
                  return package.loaded["dap"] and require("dap").status() ~= ""
                end,
                color = Util.fg("Debug"),
              },
              { require("lazy.status").updates, cond = require("lazy.status").has_updates, color = Util.fg("Special") },
              {
                "diff",
                symbols = {
                  added = icons.git.added,
                  modified = icons.git.modified,
                  removed = icons.git.removed,
                },
              },
              -- {
              --   require("copilot_status").status_string,
              -- },
              {
                function(msg)
                  msg = msg or "LS Inactive"

                  local buf_clients = vim.lsp.get_active_clients()

                  if next(buf_clients) == nil then
                    -- TODO: clean up this if statement
                    if type(msg) == "boolean" or #msg == 0 then
                      return "LS Inactive"
                    end
                    return msg
                  end

                  local buf_ft = vim.bo.filetype
                  local buf_client_names = {}
                  local copilot_active = false

                  -- -- add client
                  for _, client in pairs(buf_clients) do
                    if client.name ~= "null-ls" and client.name ~= "copilot" then
                      table.insert(buf_client_names, client.name)
                    end

                    if client.name == "copilot" then
                      copilot_active = true
                    end
                  end
                  --
                  -- -- add formatter
                  local supported_formatters = formatters_list_registered(buf_ft, "FORMATTING")
                  vim.list_extend(buf_client_names, supported_formatters)

                  -- add linter
                  local supported_linters = alternative_methods_list_registered(buf_ft)
                  vim.list_extend(buf_client_names, supported_linters)

                  local unique_client_names = vim.fn.uniq(buf_client_names)
                  local language_servers = "[" .. table.concat(unique_client_names, ", ") .. "]"

                  if copilot_active then
                    language_servers = language_servers .. "%#SLCopilot#" .. " " .. "" .. "%*"
                  end

                  return language_servers
                end,
                color = { gui = "bold" },
              },
              { "filetype", cond = nil, padding = { left = 1, right = 1 } },
            },
            lualine_z = {
              { "progress", separator = " ", padding = { left = 1, right = 0 } },
              { "location", padding = { left = 0, right = 1 } },
            },
          },
          extensions = { "neo-tree", "lazy" },
        }
      end,
    },
  },
}
