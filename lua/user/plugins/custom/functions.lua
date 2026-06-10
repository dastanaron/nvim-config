
-- Переменные для хранения состояния заметки
local note_bufnr = nil
local note_winid = nil
local note_path = nil

-- Функция для получения пути к заметке проекта
local function get_project_note_path()
    local nvim_dir = vim.fs.find('.nvim', { upward = true, type = 'directory' })[1]
    local project_root = nvim_dir and vim.fn.fnamemodify(nvim_dir, ':h') or vim.fn.getcwd()
    local note_dir = project_root .. '/.nvim'

    if vim.fn.isdirectory(note_dir) == 0 then
        vim.fn.mkdir(note_dir, 'p')
    end

    return note_dir .. '/notice'
end

-- Функция для закрытия всплывающего окна
local function close_note_popup()
    if note_winid and vim.api.nvim_win_is_valid(note_winid) then
        -- Сохраняем перед закрытием
        if note_bufnr and vim.bo[note_bufnr].modified then
            local lines = vim.api.nvim_buf_get_lines(note_bufnr, 0, -1, false)
            vim.fn.writefile(lines, note_path)
        end
        vim.api.nvim_win_close(note_winid, true)
        note_winid = nil
    end
end

-- Функция для открытия/создания заметки во всплывающем окне
local function toggle_project_note()
    -- Если окно уже открыто - закрываем его
    if note_winid and vim.api.nvim_win_is_valid(note_winid) then
        close_note_popup()
        return
    end

    -- Получаем путь к заметке
    note_path = get_project_note_path()

    -- Создаем или загружаем буфер
    if note_bufnr and vim.api.nvim_buf_is_valid(note_bufnr) then
        -- Проверяем, не открыт ли буфер в другом окне
        local buflist = vim.api.nvim_list_wins()
        local found = false
        for _, win in ipairs(buflist) do
            if vim.api.nvim_win_get_buf(win) == note_bufnr then
                found = true
                break
            end
        end
        if not found then
            vim.api.nvim_buf_delete(note_bufnr, { force = true })
            note_bufnr = nil
        end
    end

    if not note_bufnr or not vim.api.nvim_buf_is_valid(note_bufnr) then
        note_bufnr = vim.api.nvim_create_buf(false, false)
        vim.api.nvim_buf_set_name(note_bufnr, note_path)
        vim.bo[note_bufnr].filetype = 'markdown'
        vim.bo[note_bufnr].buftype = ''
        vim.bo[note_bufnr].swapfile = true
        vim.bo[note_bufnr].buflisted = false  -- Не показывать в списке буферов
    end

    -- Вычисляем размеры окна (30% ширины, 90% высоты)
    local screen_width = vim.o.columns
    local screen_height = vim.o.lines
    local win_width = math.floor(screen_width * 0.3)
    local win_height = math.floor(screen_height * 0.9)

    -- Позиция: справа сверху, с отступом
    local col = screen_width - win_width - 2
    local row = 2

    -- Открываем всплывающее окно
    local win_config = {
        relative = 'editor',
        width = win_width,
        height = win_height,
        col = col,
        row = row,
        style = 'minimal',
        border = 'rounded',
        title = ' 📝 Заметки проекта ',
        title_pos = 'center',
    }

    note_winid = vim.api.nvim_open_win(note_bufnr, true, win_config)

    -- Настраиваем локальные опции для буфера
    vim.wo[note_winid].number = false
    vim.wo[note_winid].relativenumber = false
    vim.wo[note_winid].signcolumn = 'no'
    vim.wo[note_winid].foldcolumn = '0'
    vim.wo[note_winid].spell = false
    vim.wo[note_winid].wrap = true
    vim.wo[note_winid].linebreak = true
    vim.wo[note_winid].breakindent = true
    vim.wo[note_winid].cursorline = false
    vim.wo[note_winid].colorcolumn = ''
    vim.bo[note_bufnr].modifiable = true
    vim.bo[note_bufnr].readonly = false

    -- Загружаем содержимое файла если он существует
    if vim.fn.filereadable(note_path) == 1 then
        local lines = vim.fn.readfile(note_path)
        vim.api.nvim_buf_set_lines(note_bufnr, 0, -1, false, lines)
    end
    vim.bo[note_bufnr].modified = false
    vim.bo[note_bufnr].syntax = 'markdown'

    -- Автосейв при потере фокуса
    vim.api.nvim_create_autocmd({ 'BufLeave', 'InsertLeave', 'FocusLost' }, {
        buffer = note_bufnr,
        callback = function()
            if vim.bo[note_bufnr].modified then
                local lines = vim.api.nvim_buf_get_lines(note_bufnr, 0, -1, false)
                vim.fn.writefile(lines, note_path)
                vim.bo[note_bufnr].modified = false
            end
        end,
    })

    -- Маппинг для закрытия окна
    vim.keymap.set('n', 'q', close_note_popup, { buffer = note_bufnr, noremap = true, silent = true, desc = 'Close notes' })
    vim.keymap.set('n', '<Esc>', close_note_popup, { buffer = note_bufnr, noremap = true, silent = true, desc = 'Close notes' })
end

vim.keymap.set('n', '<leader>on', toggle_project_note, {
    noremap = true,
    silent = true,
    desc = 'Toggle project notes popup'
})
