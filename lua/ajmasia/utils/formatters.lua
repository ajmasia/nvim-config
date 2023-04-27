local M = {}

local service = require("ajmasia.utils.services")
local null_ls = require("null-ls")

M.list_registered = function(filetype)
  local registered_providers = service.list_registered_providers_names(filetype)
  return registered_providers[null_ls.methods.FORMATTING] or {}
end

return M
