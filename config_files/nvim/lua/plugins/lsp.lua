return {
	"neovim/nvim-lspconfig",
	opts = {
		diagnostics = {
			virtual_text = false,
		},
	},
	keys = {
		{ "<C-]>", vim.lsp.buf.definition },
		{ "<leader>uu", vim.lsp.buf.references },
	},
	servers = {
		pyright = {},
		gopls = {},
	},
}
