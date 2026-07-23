local set = vim.api.nvim_set_hl

local green = vim.api.nvim_get_hl(0, { name = "String" }).fg
local light_blue = vim.api.nvim_get_hl(0, { name = "Identifier" }).fg

set(0, "@module", { fg = "#7aa2f7" })
set(0, "@module.builtin", { fg = "#7aa2f7", bold = true })
set(0, "@type", { fg = "#b8ffeb" })
set(0, "@property", { fg = green })
set(0, "@variable", { fg = light_blue })
set(0, "NonText", { fg = green })
set(0, "Statement", { fg = "#ffddad" })
set(0, "Normal", { bg = "#2b2b2b" })
set(0, "Constant", { fg = "#b8ffe1" })
