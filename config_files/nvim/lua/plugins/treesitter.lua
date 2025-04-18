return {
	"nvim-treesitter/nvim-treesitter",
  	cmd = { "TSUpdateSync", "TSUpdate", "TSInstall", "TSBufEnable" },
	config = function() 
		require("nvim-treesitter.configs").setup({
			highlight = {enable = true },
			ensure_installed = {
				"go",
				"lua",
				"python",
				"gotmpl",
				"yaml",
			},
		})
	end
}
	
