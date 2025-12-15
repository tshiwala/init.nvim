-- Set leader keys before anything else
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- Must be loaded before other configurations
require("plugins")

-- Load core Lua configuration
require("core")

