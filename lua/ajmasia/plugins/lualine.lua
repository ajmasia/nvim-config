return {
  {
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
              {
                function(msg)
                  msg = msg or "LS Inactive"

                  ---@diagnostic disable-next-line: missing-parameter, deprecated
                  local buf_clients = vim.lsp.buf_get_clients()

                  if next(buf_clients) == nil then
                    if type(msg) == "boolean" or #msg == 0 then
                      return "LS Inactive"
                    end

                    return msg
                  end

                  local buf_ft = vim.bo.filetype
                  local buf_client_names = {}
                  local copilot_active = false

                  -- add client
                  for _, client in pairs(buf_clients) do
                    if client.name ~= "null-ls" and client.name ~= "copilot" then
                      table.insert(buf_client_names, client.name)
                    end

                    if client.name == "copilot" then
                      copilot_active = true
                    end
                  end
                  --
                  -- add formatter
                  local supported_formatters = require("ajmasia.utils.formatters").list_registered(buf_ft)
                  ---@diagnostic disable-next-line: missing-parameter
                  vim.list_extend(buf_client_names, supported_formatters)

                  -- add linter
                  local supported_linters = require("ajmasia.utils.linters").list_registered(buf_ft)
                  ---@diagnostic disable-next-line: missing-parameter
                  vim.list_extend(buf_client_names, supported_linters)

                  local unique_client_names = vim.fn.uniq(buf_client_names)
                  local language_servers = "[" .. table.concat(unique_client_names, ", ") .. "]"

                  -- copilot status
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
