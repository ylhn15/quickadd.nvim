local M = {}

-- Format timestamp in consistent way
function M.get_timestamp()
    return os.date('%Y-%m-%d %H:%M')
end

-- Format date for wikilinks
function M.get_date_link()
    return os.date('[[%Y-%m-%d]]')
end

-- Extract filename without path and extension
function M.get_filename(filepath)
    if not filepath then
        return "No previous file"
    end
    return filepath:match("([^/]+)%.?[^%.]*$") or filepath
end

-- Ensure directory exists
function M.ensure_dir_exists(path)
    local Path = require('plenary.path')
    local dir = Path:new(path)
    if not dir:exists() then
        dir:mkdir({ parents = true })
    end
end

-- Read file content safely
function M.read_file(path)
    local ok, content = pcall(vim.fn.readfile, path)
    if not ok then
        return {}
    end
    return content
end

-- Write file content safely
function M.write_file(path, content)
    local ok, err = pcall(vim.fn.writefile, content, path)
    if not ok then
        vim.notify("Failed to write file: " .. err, vim.log.levels.ERROR)
        return false
    end
    return true
end

return M
