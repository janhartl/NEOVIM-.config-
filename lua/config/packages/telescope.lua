local telescope = require("telescope")

local builtin = require("telescope.builtin")

telescope.setup({
	defaults = {
		borderchars = {
			prompt = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
			results = { "─", "│", "─", "│", "├", "┤", "┘", "└" },
			preview = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
		},

		preview = {
			mime_hook = function(filepath, bufnr, opts)
				local function is_image(path)
					local image_extensions = { "png", "jpg", "jpeg" }
					local split_path = vim.split(path:lower(), ".", { plain = true })
					local extension = split_path[#split_path]
					return vim.tbl_contains(image_extensions, extension)
				end

				if is_image(filepath) then
					if vim.fn.executable("catimg") == 0 then
						require("telescope.previewers.utils").set_preview_message(
							bufnr,
							opts.winid,
							"catimg is not installed"
						)
						return
					end

					local term = vim.api.nvim_open_term(bufnr, {})

					local function send_output(_, data, _)
						for _, line in ipairs(data or {}) do
							vim.api.nvim_chan_send(term, line .. "\r\n")
						end
					end

					vim.fn.jobstart({
						"catimg",
						filepath,
					}, {
						on_stdout = send_output,
						stdout_buffered = true,
						pty = true,
					})
				else
					require("telescope.previewers.utils").set_preview_message(
						bufnr,
						opts.winid,
						"Binary cannot be previewed"
					)
				end
			end,
		},

		layout_config = {
			horizontal = {
				preview_cutoff = 0,
			},
		},
	},

	extensions = {
		["ui-select"] = {
			require("telescope.themes").get_dropdown({}),
		},
		fzf = {},
	},
})

pcall(telescope.load_extension, "ui-select")
pcall(telescope.load_extension, "fzf")

vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>rg", builtin.live_grep, { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })

local function telescope_highlights()
	vim.api.nvim_set_hl(0, "TelescopeNormal", {
		bg = "none",
	})

	vim.api.nvim_set_hl(0, "TelescopeBorder", {
		bg = "none",
	})

	vim.api.nvim_set_hl(0, "TelescopePromptNormal", {
		bg = "none",
	})

	vim.api.nvim_set_hl(0, "TelescopePromptBorder", {
		bg = "none",
	})

	vim.api.nvim_set_hl(0, "TelescopeResultsNormal", {
		bg = "none",
	})

	vim.api.nvim_set_hl(0, "TelescopeResultsBorder", {
		bg = "none",
	})

	vim.api.nvim_set_hl(0, "TelescopePreviewNormal", {
		bg = "none",
	})

	vim.api.nvim_set_hl(0, "TelescopePreviewBorder", {
		bg = "none",
	})
end

telescope_highlights()

vim.api.nvim_create_autocmd("ColorScheme", {
	group = vim.api.nvim_create_augroup("telescope_transparent_background", { clear = true }),
	callback = telescope_highlights,
})
