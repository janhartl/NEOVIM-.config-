return {
	{
		"ray-x/starry.nvim",
		lazy = false, -- load at startup
		priority = 1000, -- load before other colorschemes/plugins
		config = function()
			-- Setup starry with desired options
			require("starry").setup({
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
					background = true, -- <-- transparent background
					term_colors = false,
					eob_lines = false,
				},

				-- style selection: use 'deep ocean' for material deep ocean
				style = {
					name = "deep ocean", -- <-- material deep ocean style
					disable = {},
					fix = true,
					darker_contrast = false,
					daylight_swith = false,
					deep_black = false,
				},

				-- optionally tweak custom colors / highlights here
				custom_colors = {},
				custom_highlights = {},
			})

			-- apply the colorscheme
			vim.cmd("colorscheme starry")
			vim.cmd([[
        hi Normal guibg=none
        hi NormalNC guibg=none
        hi NormalFloat guibg=none
        hi SignColumn guibg=none
        hi EndOfBuffer guibg=none
      ]])
		end,
	},
}
