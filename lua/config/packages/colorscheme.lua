vim.o.termguicolors = true

local starry = require("starry")

starry.setup({
	-- window / UI settings
	border = false,
	hide_eob = true,

	-- italics
	italics = {
		comments = true,
		strings = false,
		keywords = true,
		functions = false,
		variables = false,
	},

	-- contrast toggles
	contrast = {
		enable = true,
		terminal = true,
		filetypes = {},
	},

	text_contrast = {
		lighter = false,
		darker = false,
	},

	-- disable options: background = true -> transparent
	disable = {
		background = true,
		term_colors = false,
		eob_lines = false,
	},

	-- style selection: material deep ocean style
	style = {
		name = "deep ocean",
		disable = {},
		fix = true,
		darker_contrast = false,
		daylight_swith = false,
		deep_black = false,
	},

	custom_colors = {},
	custom_highlights = {},
})

vim.cmd.colorscheme("starry")

-- Force transparent background after colorscheme loads
vim.api.nvim_create_autocmd("ColorScheme", {
	group = vim.api.nvim_create_augroup("transparent_background", { clear = true }),
	pattern = "*",
	callback = function()
		vim.cmd([[
			hi Normal guibg=none
			hi NormalNC guibg=none
			hi NormalFloat guibg=none
			hi FloatBorder guibg=none
			hi SignColumn guibg=none
			hi EndOfBuffer guibg=none
			hi LineNr guibg=none
			hi FoldColumn guibg=none
		]])
	end,
})

-- Also apply immediately
vim.cmd([[
	hi Normal guibg=none
	hi NormalNC guibg=none
	hi NormalFloat guibg=none
	hi FloatBorder guibg=none
	hi SignColumn guibg=none
	hi EndOfBuffer guibg=none
	hi LineNr guibg=none
	hi FoldColumn guibg=none
]])
