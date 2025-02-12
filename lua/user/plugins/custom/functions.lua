
-- Функция для открытия/создания заметки
local function open_project_note()
    -- Ищем корень проекта через .nvim (или используем текущую директорию)
    local nvim_dir = vim.fs.find('.nvim', { upward = true, type = 'directory' })[1]
    local project_root = nvim_dir and vim.fn.fnamemodify(nvim_dir, ':h') or vim.fn.getcwd()

  -- Пути для папки и файла с заметкой
    local note_dir = project_root .. '/.nvim'
    local note_path = note_dir .. '/notice'

    -- Создаем папку если нужно
    if vim.fn.isdirectory(note_dir) == 0 then
        vim.fn.mkdir(note_dir, 'p')
    end

    -- Открываем файл
    vim.cmd('edit ' .. vim.fn.fnameescape(note_path))
end

vim.keymap.set('n', '<leader>on', open_project_note, {
    noremap = true,
    silent = true,
    desc = 'Open project notes'
})
