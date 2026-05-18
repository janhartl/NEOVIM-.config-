local capabilities = vim.lsp.protocol.make_client_capabilities()

local blink = require("blink.cmp")
capabilities = blink.get_lsp_capabilities(capabilities)

vim.lsp.config("*", {
	capabilities = capabilities,
})

require("mason").setup()

require("mason-lspconfig").setup({
	ensure_installed = {
		"lua_ls",
		"texlab",
		"jedi_language_server",
		"ast_grep",
		"clangd",
		"jdtls",
		"html",
		"pylsp",
	},

	automatic_enable = true,
})
