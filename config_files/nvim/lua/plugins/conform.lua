return {
	"stevearc/conform.nvim",
	config = function() 
		local conf = require('conform')
		conf.setup({
			formatters_by_ft = {
				lua = { "stylua" },
				go = {"gofmt"},
				tsx = { "prettier" },
      				typescript = { "prettier" },
      				javascript = { "prettier" },
      				proto = { "buf" },
			},
			formatters = {
			      buf = {
				command = "buf",
				args = { "format", "-" }, -- read from stdin
				stdin = true,
			      },
		      },
		})

		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = "*",
			callback = function(args)
			require("conform").format({ bufnr = args.buf })
		end,
	})

	end

}
