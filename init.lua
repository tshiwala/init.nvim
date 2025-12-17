-- Set leader keys before anything else
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- Load environment variables from ~/.env
local env_file = vim.fn.expand("~/.env")
if vim.fn.filereadable(env_file) == 1 then
  for line in io.lines(env_file) do
    -- Skip comments and empty lines
    if not line:match("^%s*#") and not line:match("^%s*$") then
      -- Parse export VAR="value" or export VAR=value
      local key, value = line:match("^%s*export%s+([%w_]+)%s*=%s*['\"]?([^'\"]+)['\"]?")
      if key and value then
        vim.fn.setenv(key, value)
      end
    end
  end
end

-- Must be loaded before other configurations
require("plugins")

-- Load core Lua configuration
require("core")

