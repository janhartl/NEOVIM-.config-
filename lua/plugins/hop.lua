return {
    "smoka7/hop.nvim",
    version = "*",
    opts = {
        keys = "etovxqpdygfblzhckisuran",
    },
    config = function()
        require("hop").setup()
        vim.keymap.set("n", "<leader>hw", function()
            require("hop").hint_words()
        end, { desc = "Hop to word" })
        vim.keymap.set("n", "<leader>ha", function()
            require("hop").hint_anywhere()
        end, { desc = "Hop anywhere" })
    end,
} -- vim motions on crack
