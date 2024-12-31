A Neovim plugin for quickly adding memos and todos to your notes, very inspired by [QuickAdd for Obsidian](https://github.com/chhoumann/quickadd).

## Features

- Quick memo entry with F12 that adds to your daily notes
- Quick todo entry with F11 that adds to a todo list
- Context aware - keeps track of last edited file
- Markdown and wikilink formatting
- Configurable paths and formats

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
    "efirlus/quickadd.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = function()
        require("quickadd").setup({
            daily_note_path = "~/notes/daily/",
            todo_path = "~/notes/project/todolist.md",
        })
    end,
}
```

## Usage

Press F12 to add a quick memo to your daily note
Press F11 to add a quick todo to your todo list

## Health Check

Run :checkhealth quickadd to verify your setup.
