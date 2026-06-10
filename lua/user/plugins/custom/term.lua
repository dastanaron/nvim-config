local M = {}

local term_buf = nil
local term_win = nil
local prev_win = nil

M.toggle = function()
  -- Если окно открыто - закрываем
  if term_win and vim.api.nvim_win_is_valid(term_win) then
    vim.api.nvim_win_close(term_win, true)
    term_win = nil
    -- Возвращаемся в предыдущее окно
    if prev_win and vim.api.nvim_win_is_valid(prev_win) then
      vim.api.nvim_set_current_win(prev_win)
    end
    return
  end

  -- Сохраняем текущее окно
  prev_win = vim.api.nvim_get_current_win()

  -- Отладка: проверяем состояние
  local buf_exists = term_buf and vim.api.nvim_buf_is_valid(term_buf)
  local job = buf_exists and vim.b[term_buf].terminal_job_id
  -- Для detached процессов jobwait возвращает -1, поэтому проверяем просто наличие job
  local job_alive = job ~= nil
  
  -- Создаем буфер и терминал если нет
  local need_init = false
  if not term_buf or not vim.api.nvim_buf_is_valid(term_buf) then
    term_buf = vim.api.nvim_create_buf(false, true)
    need_init = true
  end

  -- Если терминал не запущен, запускаем
  if not job_alive then
    need_init = true
  end

  -- Размеры экрана
  local w = vim.o.columns
  local h = vim.o.lines

  -- Создаем плавающее окно с этим буфером
  term_win = vim.api.nvim_open_win(term_buf, true, {
    relative = "editor",
    row = 2,
    col = 0,
    width = w,
    height = h - 2,
    border = "none",
  })

  -- Отключаем номера строк в окне
  vim.wo[term_win].number = false
  vim.wo[term_win].relativenumber = false

  -- Инициализируем если нужно
  if need_init then
    -- Отключаем syntax и treesitter для буфера
    vim.bo[term_buf].syntax = "off"
    vim.b[term_buf].ts_disable = true
    if vim.treesitter and vim.treesitter.stop then
      pcall(vim.treesitter.stop, term_buf)
    end

    -- Помечаем буфер как немодифицированный
    vim.bo[term_buf].modified = false
    vim.bo[term_buf].modifiable = true

    -- Запускаем терминал с отключенными автокомандами
    local old_eventignore = vim.o.eventignore
    vim.o.eventignore = "all"

    job = vim.fn.termopen(vim.o.shell, {
      detach = true,  -- Не убивать процесс при закрытии окна
      on_exit = function()
        term_buf = nil
        term_win = nil
      end,
    })

    vim.o.eventignore = old_eventignore
    vim.b[term_buf].terminal_job_id = job
  end

  vim.cmd("startinsert")
end

return M
