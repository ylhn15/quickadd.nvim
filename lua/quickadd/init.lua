local popup = require("plenary.popup")
local utils = require("quickadd.utils")

local M = {
	last_buffer = nil,
	config = {
		daily_note_path = vim.fn.expand("~/notes/daily/"),
		todo_path = "~/notes/project/todolist.md",
	},
}

function M.setup(opts)
	-- Merge user config with defaults
	M.config = vim.tbl_deep_extend("force", M.config, opts or {})

	-- Set up autocommand to track last buffer
	vim.api.nvim_create_autocmd("BufLeave", {
		group = vim.api.nvim_create_augroup("QuickMemo", { clear = true }),
		callback = function()
			local bufname = vim.api.nvim_buf_get_name(0)
			if bufname ~= "" then
				M.last_buffer = bufname
			end
		end,
	})

	vim.keymap.set("n", "<leader>;;", function()
		M.show_popup("memo")
	end, { desc = "Open Quick Memo" })
	vim.keymap.set("n", "<leader>;'", function()
		M.show_popup("todo")
	end, { desc = "Open Quick Todo" })
end

function M.show_popup(type)
	local width = 60
	local height = 3
	local borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }

	local bufnr = vim.api.nvim_create_buf(false, true)

	local title
	if type == "memo" then
		title = "Quick Memo"
	elseif type == "todo" then
		title = "Quick Todo"
	end

	-- Create the popup
	local win_id = popup.create(bufnr, {
		title = title,
		line = math.floor(((vim.o.lines - height) / 2) - 1),
		col = math.floor((vim.o.columns - width) / 2),
		minwidth = width,
		minheight = height,
		borderchars = borderchars,
	})

	-- Set buffer options
	vim.bo[bufnr].modifiable = true
	vim.bo[bufnr].buftype = "nofile"
	vim.bo[bufnr].bufhidden = "wipe"
	vim.bo[bufnr].swapfile = false

	-- Enter insert mode
	vim.cmd("startinsert")

	-- Set up key mappings for this buffer
	local opts = { buffer = bufnr, noremap = true }
	vim.keymap.set("i", "<CR>", function()
		local content = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)[1]
		if type == "memo" then
			M.save_memo(content)
		elseif type == "todo" then
			M.save_todo(content)
		end
		vim.api.nvim_win_close(win_id, true)
	end, opts)

	vim.keymap.set("i", "<Esc>", function()
		vim.api.nvim_win_close(win_id, true)
	end, opts)
end

function M.save_memo(content)
	if not content or content == "" then
		return
	end

	-- Get today's date
	local date = os.date("%Y-%m-%d")
	local daily_note = M.config.daily_note_path .. date .. ".md"

	-- Ensure directory exists
	utils.ensure_dir_exists(M.config.daily_note_path)

	-- Read existing content
	local file_content = utils.read_file(daily_note)

	-- Find the "## quickadd" section
	local memo_section_index = nil
	for i, line in ipairs(file_content) do
		if line == "## Quickadd" then
			memo_section_index = i
			break
		end
	end

	-- Format the context as wikilink
	-- Extract filename without path and extension
	local filename = utils.get_filename(M.last_buffer)

	-- Format the memo as bullet point with context and timestamp
	local memo_text = string.format("- %s | %s | %s", os.date("%H:%M"), filename, content)

	-- Insert the memo after the section
	if memo_section_index then
		-- Insert after the section header, keeping existing content
		table.insert(file_content, memo_section_index + 1, memo_text)
	else
		-- If section doesn't exist, append at the end
		table.insert(file_content, "## Quickadd")
		table.insert(file_content, memo_text)
	end

	-- Write back to file
	if utils.write_file(daily_note, file_content) then
		vim.notify("Memo saved to " .. date .. ".md", vim.log.levels.INFO)
	end
end

function M.save_todo(content)
	if not content or content == "" then
		return
	end

	-- Get today's date
	local date = os.date("%Y-%m-%d")
	local daily_note = M.config.daily_note_path .. date .. ".md"

	-- Ensure directory exists
	utils.ensure_dir_exists(M.config.daily_note_path)

	-- Read existing content
	local file_content = utils.read_file(daily_note)

	-- Find the "## quickadd" section
	local memo_section_index = nil
	for i, line in ipairs(file_content) do
		if line == "## TODOs" then
			memo_section_index = i
			break
		end
	end

	-- Format the context as wikilink
	-- Extract filename without path and extension
	local filename = utils.get_filename(M.last_buffer)

	-- Format the memo as bullet point with context and timestamp
	local memo_text = string.format("%s", content)

	-- Insert the memo after the section
	if memo_section_index then
		-- Insert after the section header, keeping existing content
		table.insert(file_content, memo_section_index + 1, memo_text)
	else
		-- If section doesn't exist, append at the end
		table.insert(file_content, "## TODOs")
		table.insert(file_content, memo_text)
	end

	-- Write back to file
	if utils.write_file(daily_note, file_content) then
		vim.notify("TODO saved to " .. date .. ".md", vim.log.levels.INFO)
	end
end
