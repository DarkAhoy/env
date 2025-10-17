return {
   "tpope/vim-fugitive",
   keys = {
    {
      "<leader>gg",
      function()
        -- Check if any window has 'fugitiveblame' filetype
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          local ft = vim.api.nvim_buf_get_option(buf, "filetype")
          if ft == "fugitiveblame" then
            -- Close the blame window
            vim.api.nvim_win_close(win, true)
            return
          end
        end
	local current_win = vim.api.nvim_get_current_win()
        -- If no blame window is open, open it
        vim.cmd("G blame")
        vim.api.nvim_set_current_win(current_win)
      end,
      desc = "Toggle Git Blame",
    },
},
}
