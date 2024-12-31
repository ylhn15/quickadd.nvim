# QuickAdd.nvim

A Neovim plugin for quickly adding memos and todos to your notes, very inspired by [QuickAdd for Obsidian](https://github.com/chhoumann/quickadd). This plugin helps you capture thoughts and todos without breaking your workflow.

## Features

- Quick memo entry (F12) that adds to your daily notes with context
- Quick todo entry (F11) that adds to a dedicated todo list
- Context awareness - automatically links to your last edited file
- Markdown and wikilink formatting support
- Configurable paths and formats
- Clean interface with popup windows

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

### Quick Memo (F12)
Press F12 anywhere to add a quick memo. The memo will be added to your daily note under the "### 메모" section with the following format:
```markdown
- HH:MM | [[filename]] | Your memo content
```

### Quick Todo (F11)
Press F11 to add a todo item. It will be appended to your todo list with the following format:
```markdown
- [ ] [[YYYY-MM-DD]] : Your todo content [Created:: YYYY-MM-DD HH:MM)]
```

## Health Check

Run `:checkhealth quickadd` to verify your setup and dependencies.

## Development

This plugin is open-source and welcomes contributions. Feel free to:
- Fork and modify for your own needs
- Submit pull requests for improvements
- Open issues for bug reports or feature requests
- Share your use cases and suggestions

## Acknowledgments

- Initially created with assistance from Anthropic's Claude
- Inspired by Obsidian's QuickAdd plugin
- Built with [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) for popup functionality

## License

MIT License - feel free to modify and redistribute as you wish. See [LICENSE](LICENSE) for more details.
```

Would you like me to also create:
1. A LICENSE file with the MIT license?
2. A CONTRIBUTING.md with guidelines for contributions?
3. Add more detailed configuration examples?
