local state = {
    floating = {
        buf = -1,
        win = -1,
    },
}

local function OpenFloatingWindow(opts)
    opts = opts or {}

    local columns = vim.o.columns
    local lines = vim.o.lines

    -- Default to 60% of screen size
    local width = opts.width or math.floor(columns * 0.6)
    local height = opts.height or math.floor(lines * 0.6)

    -- Center position
    local row = math.floor((lines - height) / 2)
    local col = math.floor((columns - width) / 2)

    -- Create a buffer that can be reused
    local buf = nil
    if vim.api.nvim_buf_is_valid(opts.buf) then 
        buf = opts.buf
    else
        buf = vim.api.nvim_create_buf(false, true)
    end

    local win_opts = {
        style = "minimal",
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        border = "solid",
    }

    -- Open the floating window
    local win = vim.api.nvim_open_win(buf, true, win_opts)


    return { buf = buf, win = win }
end

local toggle_terminal = function()
    if not vim.api.nvim_win_is_valid(state.floating.win) then
        state.floating = OpenFloatingWindow { buf = state.floating.buf }
        if vim.bo[state.floating.buf].buftype ~= 'terminal' then
            vim.cmd.term()
        end
    else
        vim.api.nvim_win_hide(state.floating.win)
    end
end

-- make a command
vim.api.nvim_create_user_command("Floaterminal", toggle_terminal, {})
vim.keymap.set({"n", "t"}, "<space>tt", toggle_terminal)

