-- treesitter requires build before it is added
local function build_telescope_fzf_native(path)
	if vim.fn.executable("cmake") == 0 then
		vim.notify("cmake is required to build telescope-fzf-native.nvim", vim.log.levels.ERROR)
		return
	end

	local configure = vim.system({
		"cmake",
		"-S.",
		"-Bbuild",
		"-DCMAKE_BUILD_TYPE=Release",
	}, { cwd = path }):wait()

	if configure.code ~= 0 then
		vim.notify("Failed to configure telescope-fzf-native.nvim", vim.log.levels.ERROR)
		return
	end

	local build = vim.system({
		"cmake",
		"--build",
		"build",
		"--config",
		"Release",
	}, { cwd = path }):wait()

	if build.code ~= 0 then
		vim.notify("Failed to build telescope-fzf-native.nvim", vim.log.levels.ERROR)
		return
	end

	vim.notify("Built telescope-fzf-native.nvim", vim.log.levels.INFO)
end

vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local data = ev.data or {}
		local spec = data.spec or {}
		local kind = data.kind
		local path = data.path

		if spec.name ~= "telescope-fzf-native.nvim" then
			return
		end

		if kind ~= "install" and kind ~= "update" then
			return
		end

		build_telescope_fzf_native(path)
	end,
})

vim.api.nvim_create_user_command("BuildTelescopeFzfNative", function()
	local path = vim.fn.stdpath("data") .. "/site/pack/core/opt/telescope-fzf-native.nvim"
	build_telescope_fzf_native(path)
end, {})
-- end treesitter

vim.pack.add({
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/ray-x/starry.nvim",

	"https://github.com/neovim/nvim-lspconfig",

    "https://github.com/rafamadriz/friendly-snippets",
    "https://github.com/saghen/blink.lib",
    "https://github.com/saghen/blink.cmp",

	"https://github.com/williamboman/mason.nvim",
	"https://github.com/williamboman/mason-lspconfig.nvim",

	"https://github.com/ThePrimeagen/harpoon",
	"https://github.com/nvim-lua/plenary.nvim",

	"https://github.com/smoka7/hop.nvim",

	"https://github.com/stevearc/oil.nvim",
	"https://github.com/echasnovski/mini.icons",

	"https://github.com/nvim-telescope/telescope.nvim",
	"https://github.com/nvim-telescope/telescope-fzf-native.nvim",
	"https://github.com/nvim-telescope/telescope-ui-select.nvim",

    "https://github.com/mbbill/undotree",

})
