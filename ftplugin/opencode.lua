if vim.b.did_ftplugin then
  return
end
vim.b.did_ftplugin = true
-- Auto-attach opencode LSP to opencode input buffers

-- This provides completion for files, subagents, commands, and context items
-- Works with any LSP-compatible completion plugin (blink.cmp, nvim-cmp, etc.)

local bufnr = vim.api.nvim_get_current_buf()

local opencode_completion_ls = require('opencode.lsp.opencode_completion_ls')
local client_id = opencode_completion_ls.start(bufnr)
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
-- blink.cmp capabilities
-- completion = {
--   completionItem = {
--     commitCharactersSupport = false,
--     deprecatedSupport = true,
--     documentationFormat = { "markdown", "plaintext" },
--     insertReplaceSupport = true,
--     preselectSupport = false,
--     resolveSupport = {
--       properties = { "additionalTextEdits", "command" }
--     },
--     snippetSupport = true,
--     tagSupport = {
--       valueSet = { 1 }
--     }
--   },
--   completionItemKind = {
--     valueSet = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25 }
--   },
--   completionList = {
--     itemDefaults = { "editRange", "insertTextFormat", "insertTextMode", "data" }
--   },
--   contextSupport = true,
--   dynamicRegistration = false
-- },

-- cmp capabilities
-- completion = {
--   completionItem = {
--     commitCharactersSupport = false,
--     deprecatedSupport = true,
--     documentationFormat = { "markdown", "plaintext" },
--     insertReplaceSupport = true,
--     preselectSupport = false,
--     resolveSupport = {
--       properties = { "additionalTextEdits", "command" }
--     },
--     snippetSupport = true,
--     tagSupport = {
--       valueSet = { 1 }
--     }
--   },
--   completionItemKind = {
--     valueSet = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25 }
--   },
--   completionList = {
--     itemDefaults = { "editRange", "insertTextFormat", "insertTextMode", "data" }
--   },
--   contextSupport = true,
--   dynamicRegistration = false
-- },
