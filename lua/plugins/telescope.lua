return{ 

	{
   	 	'nvim-telescope/telescope.nvim', version = '*',
   		 dependencies = {
   		     'nvim-lua/plenary.nvim',
   	     		-- optional but recommended
       		 { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },

   		},
		config = function()
			require('telescope').setup {
				pickers = {
					find_files = {
						theme = "ivy"
					}
				}
			}


			vim.keymap.set("n", "<space>fw", function()
				require('telescope.builtin').grep_string({search = vim.fn.input("Grep > ") })
			end)
			vim.keymap.set("n", "<space>fg", require('telescope.builtin').git_files)
			vim.keymap.set("n", "<space>fh", require('telescope.builtin').help_tags)
			vim.keymap.set("n", "<space>fd", require('telescope.builtin').find_files)   
			vim.keymap.set("n", "<space>fc", function()
				require('telescope.builtin').find_files {
					cwd = vim.fn.stdpath("config")
					}
		  end)
		end
	}

}
