return {
	{
		"hrsh7th/cmp-nvim-lsp",
	},
	{
		"L3MON4D3/LuaSnip",
		dependencies = {
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
		},
	},
	{
		"hrsh7th/nvim-cmp",
		config = function()
			local cmp = require("cmp")
			cmp.setup({
				preselect = cmp.PreselectMode.None,
				snippet = {
					expand = function(args) 
						require("luasnip").lsp_expand(args.body)
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
			    	mapping = cmp.mapping.preset.insert({
					['<Down>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
					['<Up>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
					['<CR>'] = cmp.mapping.confirm({select = true}),
					['<C-Space>'] = cmp.mapping.complete(),
			    	}),
				sources = cmp.config.sources({
					{name = "nvim_lsp"},
					{name = "buffer"}
				}),
			})
		end
	},
}
