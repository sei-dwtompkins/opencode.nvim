if vim.b.did_ftplugin then
  return
end
vim.b.did_ftplugin = true
-- Auto-attach opencode LSP to opencode input buffers

-- This provides completion for files, subagents, commands, and context items
-- Works with any LSP-compatible completion plugin (blink.cmp, nvim-cmp, etc.)

local bufnr = vim.api.nvim_get_current_buf()

local opencode_ls = require('opencode.lsp.opencode_ls')
local client_id = opencode_ls.start(bufnr)
local completion = require('opencode.ui.completion')
local config = require('opencode.config')
local use_native_completion = config.ui.completion.use_native_completion

if client_id then
  -- track insert start state
  vim.api.nvim_create_autocmd('InsertEnter', {
    buffer = bufnr,
    callback = function()
      if use_native_completion then
        vim.lsp.completion.enable(true, client_id, bufnr, { autotrigger = true })
      end
      completion.on_insert_enter()
    end,
  })

  vim.api.nvim_create_autocmd('TextChangedI', {
    buffer = bufnr,
    callback = function(e)
      completion.on_text_changed()
    end,
  })
end
