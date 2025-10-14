return {
	"savq/paq-nvim",
	"frabjous/knap",
    config = function()
        vim.keymap.set({ 'n', 'v', 'i' },'<F7>', function() require("knap").toggle_autopreviewing() end)
    end,
}
