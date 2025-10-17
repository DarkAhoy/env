
return {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
     dependencies = { 'nvim-lua/plenary.nvim' },
     keys = {
	{"<c-p>", "<cmd>Telescope find_files<cr>"},
	{"<leader>ff", "<cmd>Telescope live_grep<cr>"},
	{"<leader>rr", "<cmd>Telescope resume<cr>"},
     },
     config = function() 
	     local actions = require('telescope.actions')
	     require('telescope').setup({
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
}
