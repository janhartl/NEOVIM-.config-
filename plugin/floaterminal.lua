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

  local width = opts.width or math.floor(columns * 0.6)
  local height = opts.height or math.floor(lines * 0.6)

  local row = math.floor((lines - height) / 2)
  local col = math.floor((columns - width) / 2)

  -- Create or reuse buffer safely
  local buf
  if opts.buf and vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true)
    -- Mark as unlisted and unsavable
    vim.api.nvim_buf_set_option(buf, "buflisted", false)
    vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
    vim.api.nvim_buf_set_option(buf, "swapfile", false)
    pcall(vim.api.nvim_buf_set_option, buf, "modified", false)
  end

  local win_opts = {
    style = "minimal",
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    border = "rounded",
  }

  local win = vim.api.nvim_open_win(buf, true, win_opts)

  -- Reset state when manually closed
  vim.api.nvim_create_autocmd("WinClosed", {
    pattern = tostring(win),
    once = true,
    callback = function()
      state.floating.win = -1
    end,
  })

  return { buf = buf, win = win }
end

local function toggle_terminal()
  if not vim.api.nvim_win_is_valid(state.floating.win) then
    state.floating = OpenFloatingWindow({ buf = state.floating.buf })

    if vim.bo[state.floating.buf].buftype ~= "terminal" then
      vim.cmd.term()
    else
      vim.cmd.startinsert()
    end
  else
    vim.api.nvim_win_hide(state.floating.win)
    state.floating.win = -1
  end
end

-- Keep centered on resize
vim.api.nvim_create_autocmd("VimResized", {
  callback = function()
    if vim.api.nvim_win_is_valid(state.floating.win) then
      local cfg = vim.api.nvim_win_get_config(state.floating.win)
      local columns = vim.o.columns
      local lines = vim.o.lines
      cfg.row = math.floor((lines - cfg.height) / 2)
      cfg.col = math.floor((columns - cfg.width) / 2)
      vim.api.nvim_win_set_config(state.floating.win, cfg)
    end
  end,
})

-- Command + keymap
vim.api.nvim_create_user_command("Floaterminal", toggle_terminal, {})
vim.keymap.set({ "n", "t" }, "<space>tt", toggle_terminal, { desc = "Toggle floating terminal" })

