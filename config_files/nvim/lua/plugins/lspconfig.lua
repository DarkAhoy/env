return {
	{
	  "williamboman/mason.nvim",
	  config = function() 
		require("mason").setup()
	  end
	},
	{
	  "williamboman/mason-lspconfig.nvim",
	  dependencies = {
	  	"williamboman/mason.nvim",
	  },
	   config = function()
		   require("mason-lspconfig").setup({
			ensure_installed = {
				"lua_ls",
				"gopls",
				"pylsp",
			},
		})
	   end,
	},
	{
	"neovim/nvim-lspconfig",
	event = { 'BufReadPre', 'BufReadPost', 'BufNewFile' },
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp",
	},
	config = function()
		local capabilities = require("cmp_nvim_lsp").default_capabilities()
		local servers = {
			 gopls = {
				cmd = { "gopls" }, -- Use the local gopls binary
				filetypes = { "go", "gomod", "gowork", "gotmpl" },
				root_dir = require("lspconfig.util").root_pattern("go.work", "go.mod", ".git"),
				settings = {
				  gopls = {
				    analyses = {
				      unusedparams = true,
				    },
				    staticcheck = true,
				  },
				},
			},
			--lua_ls = {},
			pylsp = {},
			ts_ls = {},
		}

		for server, server_opts in pairs(servers) do
			require("lspconfig")[server].setup({capabilities = capabilities})
		end

		vim.api.nvim_create_autocmd('LspAttach', {
            		group = vim.api.nvim_create_augroup('UserLspConfig', {}),
			callback = function() 
				vim.keymap.set('n', "<C-]>", vim.lsp.buf.definition )
				vim.keymap.set('n', "<leader>uu", vim.lsp.buf.references  )
				vim.keymap.set('n', "<leader>ca", vim.lsp.buf.code_action  )
				vim.keymap.set('n', "<leader>tt", vim.diagnostic.open_float )
				vim.keymap.set('n', "<leader>rn", vim.lsp.buf.rename )
			end
		})
	end
	},
}
