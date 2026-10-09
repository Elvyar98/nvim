-- Move lines in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Better J and centering motions
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "=ap", "ma=ap'a")

-- Paste without overwriting the register
vim.keymap.set("x", "<leader>p", [["_dP]])

-- Delete to black hole
vim.keymap.set({ "n", "v" }, "<leader>d", '"_d')

-- Exit insert mode
vim.keymap.set("i", "<C-c>", "<Esc>")

-- Disable Q (macro record on accident)
vim.keymap.set("n", "Q", "<nop>")

-- Go error snippets
vim.keymap.set("n", "<leader>ee", "oif err != nil {<CR>}<Esc>Oreturn err<Esc>")
vim.keymap.set("n", "<leader>ea", 'oassert.NoError(err, "")<Esc>F";a')
vim.keymap.set("n", "<leader>ef", 'oif err != nil {<CR>}<Esc>Olog.Fatalf("error: %s\\n", err.Error())<Esc>jj')
vim.keymap.set("n", "<leader>el", 'oif err != nil {<CR>}<Esc>O.logger.Error("error", "error", err)<Esc>F.;i')

-- Source current file
vim.keymap.set("n", "<leader><leader>", function()
	vim.cmd("so")
end)
