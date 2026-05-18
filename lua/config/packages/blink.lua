local blink = require("blink.cmp")

blink.setup({
	keymap = {
		preset = "default",

    ["<Tab>"] = {
			"select_and_accept",
			"fallback",
		},

		["<S-Tab>"] = {
			"select_prev",
			"fallback",
		},
	},

	appearance = {
		nerd_font_variant = "mono",
	},

	fuzzy = {
		implementation = "lua",
	},

	completion = {
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 250,
		},

		menu = {
			auto_show = true,
		},

		list = {
			selection = {
				preselect = false,
				auto_insert = true,
			},
		},
	},

	signature = {
		enabled = true,
	},

	sources = {
		default = {
			"lsp",
			"path",
			"snippets",
			"buffer",
		},
	},
})
