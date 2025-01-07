local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- File Explorer (NERDTree)
map('n', '<C-n>', ':NERDTreeToggle<CR>', opts)
-- LSP Mappings
map('n', 'gD', vim.lsp.buf.declaration, opts)
map('n', 'gd', vim.lsp.buf.definition, opts)
map('n', 'gi', vim.lsp.buf.implementation, opts)
map('n', 'gr', vim.lsp.buf.references, opts)
map('n', 'K', vim.lsp.buf.hover, opts)
map('n', '<C-k>', vim.lsp.buf.signature_help, opts)
map('n', '<C-r>', vim.lsp.buf.rename, opts)
map('n', '<C-a>', vim.lsp.buf.code_action, opts)
map('n', '<C-f>', function() 
    vim.lsp.buf.format { async = true } 
end, opts)
map('n', '<C-d>', vim.lsp.buf.type_definition, opts)

-- LLM Integration
map("n", "<leader>m", function()
    require("llm").create_llm_md()
end, { desc = "Create llm.md" })

-- Anthropic bindings
map("n", "<leader>g,", function()
    require("llm").prompt({ replace = false, service = "anthropic" })
end, { desc = "Prompt with Claude" })
map("v", "<leader>g,", function()
    require("llm").prompt({ replace = false, service = "anthropic" })
end, { desc = "Prompt with Claude" })
map("v", "<leader>g.", function()
    require("llm").prompt({ replace = true, service = "anthropic" })
end, { desc = "Prompt while replacing with Claude" })
