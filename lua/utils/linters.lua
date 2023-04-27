local M = {}

local service = require("utils.services")
local null_ls = require("null-ls")

local alternative_methods = {
  null_ls.methods.DIAGNOSTICS,
  null_ls.methods.DIAGNOSTICS_ON_OPEN,
  null_ls.methods.DIAGNOSTICS_ON_SAVE,
}

M.list_registered = function(filetype)
  local registered_providers = service.list_registered_providers_names(filetype)
  local providers_for_methods = vim.tbl_flatten(vim.tbl_map(function(m)
    return registered_providers[m] or {}
  end, alternative_methods))

  return providers_for_methods
end

return M
