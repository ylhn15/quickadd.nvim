local M = {}

function M.check()
    local health = vim.health or require("health")

    health.start("QuickAdd Health Check")

    -- Check for required dependencies
    local has_plenary, _ = pcall(require, "plenary.popup")
    if has_plenary then
        health.ok("plenary.nvim installed")
    else
        health.error("plenary.nvim not installed", {
            "Install plenary.nvim: https://github.com/nvim-lua/plenary.nvim"
        })
    end

    -- Check if configured paths exist
    local config = require("quickadd").config
    if config then
        local Path = require("plenary.path")

        -- Check daily note directory
        local daily_path = Path:new(vim.fn.expand(config.daily_note_path))
        if daily_path:exists() then
            health.ok("Daily notes directory exists: " .. config.daily_note_path)
        else
            health.warn("Daily notes directory doesn't exist: " .. config.daily_note_path, {
                "Directory will be created when first memo is saved",
                "Or create it manually: mkdir -p " .. config.daily_note_path
            })
        end

        -- Check todo file directory
        local todo_path = Path:new(vim.fn.expand(config.todo_path)):parent()
        if todo_path:exists() then
            health.ok("Todo directory exists: " .. todo_path.filename)
        else
            health.warn("Todo directory doesn't exist: " .. todo_path.filename, {
                "Directory will be created when first todo is saved",
                "Or create it manually: mkdir -p " .. todo_path.filename
            })
        end
    else
        health.error("QuickAdd not configured")
    end
end

return M
