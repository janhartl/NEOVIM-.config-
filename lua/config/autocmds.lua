vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking text",
    group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
    callback = function()
        vim.hl.on_yank()
    end,
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp_completion", { clear = true }),
	callback = function(args)
		local client_id = args.data.client_id
		if not client_id then
			return
		end

		vim.lsp.completion.enable(false, client_id, args.buf)

		vim.bo[args.buf].omnifunc = nil
		vim.bo[args.buf].completefunc = nil
	end,
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp_format_on_save", { clear = true }),
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if not client then
			return
		end

		if not client:supports_method("textDocument/formatting") then
			return
		end

		vim.api.nvim_create_autocmd("BufWritePre", {
			group = vim.api.nvim_create_augroup("lsp_format_on_save_buf_" .. args.buf, { clear = true }),
			buffer = args.buf,
			callback = function()
				vim.lsp.buf.format({
					bufnr = args.buf,
					timeout_ms = 2000,
				})
			end,
		})
	end,
})
