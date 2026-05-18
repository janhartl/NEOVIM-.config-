require("mini.icons").setup()

require("oil").setup({})

vim.keymap.set("n", "<leader>pv", "<cmd>Oil<cr>", {
    desc = "Open parent directory",
})
