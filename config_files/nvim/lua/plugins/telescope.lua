
return {
    {'nvim-telescope/telescope.nvim', 
     dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope-ui-select.nvim' },
     keys = {
	{"<c-p>", "<cmd>Telescope find_files<cr>"},
	{"<leader>ff", "<cmd>Telescope live_grep<cr>"},
	{"<leader>rr", "<cmd>Telescope Resulme<cr>"},
     },
     config = function()
	     local actions = require('telescope.actions')
	     require('telescope').setup({
             extensions = {
                ["ui-select"] = {
                    require("telescope.themes").get_dropdown {}
                },
             },
		     defaults = {
			     file_ignore_patterns = {"node_modules"},
			     mappings = {
				i = {
					["<esc>"] = actions.close,
					["<c-i>"] = actions.select_vertical,
					["<c-s>"] = actions.select_horizontal,
				},
			     },
		     },
     	})
     end
     },
     {
    "nvim-telescope/telescope-ui-select.nvim",
  }
}
