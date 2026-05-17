return {
	"stevearc/conform.nvim",
	opts = {},
	config = function()
		local conform = require("conform")
		conform.setup({
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "black" },
				c = { "clang_format" },
				latex = { "tex-fmt" },
				java = { "clang_format" },
			},
		})
		vim.keymap.set("n", "<leader>fo", conform.format, {})
	end,
}
