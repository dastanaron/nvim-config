
local M = {}
local panel_win = nil
local latestActiveBuffer = nil

-- Получение списка буферов
local function get_buffers()
  local buffers = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.fn.buflisted(buf) == 1 then
      local name = vim.api.nvim_buf_get_name(buf)
      table.insert(buffers, {
        id = buf,
        name = name ~= "" and name or "[No Name]",
        active = buf == latestActiveBuffer
      })
    end
  end
  return buffers
end

-- Отрисовка панели
function M.toggle_panel()
  if panel_win and vim.api.nvim_win_is_valid(panel_win) then
    vim.api.nvim_win_close(panel_win, true)
    panel_win = nil
    latestActiveBuffer = nil
    return
  end

  latestActiveBuffer = vim.api.nvim_get_current_buf()

  -- Создание плавающего окна
  local width = math.floor(vim.o.columns * 0.3)
  local buf = vim.api.nvim_create_buf(false, true)
  panel_win = vim.api.nvim_open_win(
    buf,
    true,
    {
      relative = "win",
      width = width,
      height = vim.o.lines - 3,
      col = vim.o.columns - width,
      row = 0,
      style = "minimal",
    }
  )

  vim.api.nvim_buf_set_name(buf, "BuffersList_" .. panel_win)

  -- Обновление содержимого
  M.update_panel()
end

-- Обновление содержимого панели
function M.update_panel()
  if not panel_win or not vim.api.nvim_win_is_valid(panel_win) then return end

  local lines = {}
  local buffers = get_buffers()

  for _, buf in ipairs(buffers) do
    local line = string.format(" %d │ %s %s", 
      buf.id, 
      buf.active and "●" or " ", 
      buf.name:gsub("^" .. vim.env.HOME, "~")
    )
    table.insert(lines, line)
  end

  vim.api.nvim_buf_set_lines(vim.api.nvim_win_get_buf(panel_win), 0, -1, false, lines)
  
  -- Настройка ключевых команд
  vim.api.nvim_buf_set_keymap(0, 'n', '<CR>', 
    [[:lua require('user.plugins.buffer_panel').switch_buffer()<CR>]], 
    {silent = true}
  )
end

-- Переключение на выбранный буфер
function M.switch_buffer()
  local line = vim.api.nvim_get_current_line()
  local buf_id = tonumber(line:match("%d+"))

  if buf_id and vim.api.nvim_buf_is_valid(buf_id) then
    M.toggle_panel()
    vim.cmd("buffer " .. buf_id)
  end
end

-- Инициализация
function M.setup()
  vim.api.nvim_create_user_command("ToggleBufferPanel", M.toggle_panel, {})
  vim.api.nvim_create_autocmd({"BufAdd", "BufDelete"}, {
    callback = M.update_panel
  })
end

return M
