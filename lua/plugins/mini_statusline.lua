return {
	{
		"echasnovski/mini.nvim",
		config = function()
			local statusline = require("mini.statusline")
			statusline.setup({ use_icons = true, set_vim_settings = true })
			-- Apply Material Deep Ocean colors
			vim.api.nvim_set_hl(0, "MiniStatuslineModeNormal", { fg = "#1e2132", bg = "#82aaff", bold = true })
			vim.api.nvim_set_hl(0, "MiniStatuslineModeInsert", { fg = "#1e2132", bg = "#c3e88d", bold = true })
			vim.api.nvim_set_hl(0, "MiniStatuslineModeVisual", { fg = "#1e2132", bg = "#c099ff", bold = true })
			vim.api.nvim_set_hl(0, "MiniStatuslineModeReplace", { fg = "#1e2132", bg = "#ff757f", bold = true })
			vim.api.nvim_set_hl(0, "MiniStatuslineModeCommand", { fg = "#1e2132", bg = "#ffc777", bold = true })
			vim.api.nvim_set_hl(0, "MiniStatuslineInactive", { fg = "#828bb8", bg = "NONE" })
			vim.api.nvim_set_hl(0, "MiniStatuslineFilename", { fg = "#c8d3f5", bg = "NONE" })
			vim.api.nvim_set_hl(0, "MiniStatuslineDevinfo", { fg = "#86e1fc", bg = "NONE" })
		end,
	},
}
