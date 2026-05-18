local hop = require("hop")

hop.setup({
    keys = "etovxqpdygfblzhckisuran",
})

vim.keymap.set("n", "<leader>hw", function()
    hop.hint_words()
end, { desc = "Hop to word" })

vim.keymap.set("n", "<leader>ha", function()
    hop.hint_anywhere()
end, { desc = "Hop anywhere" })
