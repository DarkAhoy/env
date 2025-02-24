actions = require("telescope.actions")

return {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
     dependencies = { 'nvim-lua/plenary.nvim' },
     mappings = {
	["<esc>"] = actions.close,
	["<c-i>"] = actions.select_vertical,
	["<c-s>"] = actions.select_horizontal,
     },
     keys = {
	{"<C-p>", "<cmd>Telescope find_files<cr>"},
	{"<leader>ff", "<cmd>Telescope live_grep<cr>"},
     },
    }
