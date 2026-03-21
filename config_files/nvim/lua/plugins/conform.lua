return {
	"stevearc/conform.nvim",
	config = function()
		local conf = require('conform')
		conf.setup({
			formatters_by_ft = {
				lua = { "stylua" },
				go = { "golangci" },
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
                golangci = {
                    command = "golangci-lint",    
                    args = { "fmt", "--config=/Users/amosarbiv/src/network/.golangci.yml", "--stdin" },
                    stdin = true
                }
		      },
		})

		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = "*",
			callback = function(args)
			require("conform").format({ bufnr = args.buf, async = false })
		end,

        vim.api.nvim_create_user_command(
          "Format",
          function()
            local current_buf = vim.api.nvim_get_current_buf()
			require("conform").format({ bufnr = current_buf })
          end,
          {
            desc = "A simple custom command", -- Optional description for the command
            nargs = 0, -- Specifies that the command takes no arguments
          })
	    })

	end
}
