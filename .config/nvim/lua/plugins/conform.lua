return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = function()
    local util = require("conform.util")

    local function js_formatter(bufnr)
      if util.root_file({
        ".prettierrc",
        ".prettierrc.json",
        "prettier.config.js",
      })(bufnr) then
        return { "prettier" }
      end

      return { "oxfmt" }
    end

    return {
      formatters_by_ft = {
        javascript = js_formatter,
        javascriptreact = js_formatter,
        typescript = js_formatter,
        typescriptreact = js_formatter,
      },
    }
  end,
}
