return {
	"stevearc/conform.nvim",
	config = function() 
		local conf = require('conform')
		conf.setup({
			formatters_by_ft = {
				lua = { "stylua" },
				go = {"gofmt"},
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
