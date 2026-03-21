return {
  "neovim/nvim-lspconfig",
  config = function()
    local servers = {
      gopls = {},
        --cmd = { "gopls" },
        --filetypes = { "go", "gomod", "gowork", "gotmpl" },
--
        --root_dir = function(bufnr)
          --return vim.fs.root(bufnr, { "go.work", "go.mod", ".git" })
        --end,
        --settings = {
          --gopls = {
            --analyses = {
              --unusedparams = true,
            --},
            --staticcheck = true,
          --},
        --},
      --},
      lua_ls = {},
    }

    for name, config in pairs(servers) do
      vim.lsp.config(name, config)
      vim.lsp.enable(name)
    end

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
      callback = function(args)
        local opts = { buffer = args.buf }

        vim.keymap.set("n", "<C-]>", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "<leader>uu", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "<leader>tt", vim.diagnostic.open_float, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set(
          "n",
          "<leader>ii",
          require("telescope.builtin").lsp_implementations,
          opts
        )
      end,
    })
  end,
}

