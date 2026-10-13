local HOME = vim.fn.expand("~")
local VAULT = HOME .. "/Desktop/obsidian_vaults/Elvis"
local TEMPLATES_DIR = "0002 Resources/0002 Templates"
local JOURNALS = "0002 Resources/0006 Journals"

local function translate_date_fmt(fmt)
	return fmt:gsub("YYYY", "%%Y")
		:gsub("YY", "%%y")
		:gsub("MMMM", "%%B")
		:gsub("MMM", "%%b")
		:gsub("MM", "%%m")
		:gsub("DD", "%%d")
		:gsub("HH", "%%H")
		:gsub("mm", "%%M")
		:gsub("ss", "%%S")
end

local function render_template(template_name, title)
	local path = VAULT .. "/" .. TEMPLATES_DIR .. "/" .. template_name .. ".md"
	local content = table.concat(vim.fn.readfile(path), "\n")

	content = content:gsub("{{date:([^}]+)}}", function(fmt)
		return os.date(translate_date_fmt(fmt))
	end)
	content = content:gsub("{{date}}", os.date("%Y-%m-%d"))
	content = content:gsub("{{time}}", os.date("%H:%M"))
	content = content:gsub("{{title}}", title)

	return content
end

local function create_note(template_name, folder, title_fn)
	return function()
		local title = title_fn and title_fn() or vim.fn.input("Title: ")
		if title == "" then
			return
		end

		local body = render_template(template_name, title)
		local file_path = VAULT .. "/" .. folder .. "/" .. title .. ".md"

		vim.fn.mkdir(vim.fn.fnamemodify(file_path, ":h"), "p")
		vim.fn.writefile(vim.split(body, "\n"), file_path)
		vim.cmd("edit " .. vim.fn.fnameescape(file_path))
	end
end

local function monthly_title()
	return os.date("%Y-%m")
end
local function yearly_title()
	return os.date("%Y")
end
local function quarterly_title()
	return os.date("%Y") .. "-Q" .. math.ceil(tonumber(os.date("%m")) / 3)
end
local function weekly_title()
	return vim.fn.system("date +%G-W%V"):gsub("%s+", "")
end

return {
	"obsidian-nvim/obsidian.nvim",
	version = "*",
	ft = "markdown",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MeanderingProgrammer/render-markdown.nvim",
	},
	opts = {
		workspaces = {
			{ name = "elvis", path = VAULT },
			ui = { enable = false },
		},
		templates = {
			folder = TEMPLATES_DIR,
			date_format = "%Y-%m-%d",
			time_format = "%H:%M",
		},
		daily_notes = {
			folder = JOURNALS .. "/Daily",
			date_format = "%Y-%m-%d",
			alias_format = "%B %-d, %Y",
			default_tags = { "daily-notes" },
			template = "HUMAN 3.0 Daily Development Dashboard.md",
		},
	},
	keys = {
		-- Daily notes (LazyVim default)
		{ "<leader>od", "<cmd>Obsidian today<CR>", desc = "Today's daily note" },

		-- Template creation — all under capital letters to avoid LazyVim collisions
		{ "<leader>oZ", create_note("Zettle Note", "0002 Resources/000 Zettlekasten"), desc = "New Zettel note" },
		{
			"<leader>oF",
			create_note("Short Form Template", "0002 Resources/000 Zettlekasten"),
			desc = "New Short Form note",
		},
		{ "<leader>oL", create_note("Long Form Note", "0002 Resources/0004 Articles"), desc = "New Long Form note" },
		{ "<leader>oB", create_note("Book Note Template", "0002 Resources/0003 Books"), desc = "New Book note" },
		{ "<leader>oC", create_note("Course Template", "0002 Resources/0005 Courses"), desc = "New Course note" },
		{ "<leader>oP", create_note("Person Template", "0001 Area/0002 Spirit/People"), desc = "New Person note" },
		{ "<leader>oR", create_note("Research Note Template", "0000 Projects"), desc = "New Research note" },
		{ "<leader>oJ", create_note("Project Note Template", "0000 Projects"), desc = "New Project note" },

		-- Reviews (auto-titled)
		{
			"<leader>oM",
			create_note("HUMAN 3.0 Monthly Review", JOURNALS .. "/Monthly", monthly_title),
			desc = "Monthly review",
		},
		{
			"<leader>oQ",
			create_note("HUMAN 3.0 Quarterly Review Template", JOURNALS .. "/Quarterly", quarterly_title),
			desc = "Quarterly review",
		},
		{
			"<leader>oW",
			create_note("HUMAN 3.0 Weekly Review", JOURNALS .. "/Weekly", weekly_title),
			desc = "Weekly review",
		},
		{
			"<leader>oY",
			create_note("HUMAN 3.0 Yearly Review", JOURNALS .. "/Yearly", yearly_title),
			desc = "Yearly review",
		},

		-- Smart Enter: follow link when on a link
		{
			"<CR>",
			function()
				if require("obsidian").util.cursor_on_markdown_link() then
					return "<cmd>Obsidian follow_link<CR>"
				else
					return "<CR>"
				end
			end,
			expr = true,
			desc = "Follow link",
			ft = "markdown",
		},
	},
}
