vim.keymap.set("n", "<leader>q", function()
    vim.cmd('let @/ = ""')
end)

vim.keymap.set('n', 'c', '"_c', opts)
vim.keymap.set('n', 'x', '"_x', opts)
