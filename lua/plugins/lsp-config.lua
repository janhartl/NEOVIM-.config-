return {
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = true,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		opts = {
			auto_install = true,
		},
	},

	"neovim/nvim-lspconfig",
	dependencies = {
		{
			"folke/lazydev.nvim",
			ft = "lua",
			opts = {
				library = {
					{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				},
			},
		},
		"saghen/blink.cmp",
	},
	opts = {
		servers = {
			lua_ls = {},
			texlab = {},
			jedi_language_server = {},
			ast_grep = {},
			clangd = {},
			solargraph = {},
		},
	},
	config = function(_, opts)
		local capabilities = require("blink.cmp").get_lsp_capabilities()

		local on_attach = function(_, bufnr)
			local keymap = vim.keymap.set
			local opts = { buffer = bufnr, silent = true }
			keymap("n", "K", vim.lsp.buf.hover, opts)
			keymap("n", "<leader>gd", vim.lsp.buf.definition, opts)
			keymap("n", "<leader>gr", vim.lsp.buf.references, opts)
			keymap("n", "<leader>ca", vim.lsp.buf.code_action, opts)
		end

		-- Loop through servers
		for server, config in pairs(opts.servers) do
			vim.lsp.config(
				server,
				vim.tbl_deep_extend("force", config, {
					on_attach = on_attach,
					capabilities = capabilities,
				})
			)

			vim.lsp.enable(server)
		end
	end,
}
