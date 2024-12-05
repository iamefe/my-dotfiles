# My NvChad Dotfiles

## For new Nvchad installation

Install Neovim this from https://github.com/neovim/neovim

Then install NvChad this way.

```sh
git clone https://github.com/NvChad/starter ~/.config/nvim && nvim
```

After which you should follow the remaining instructions at
https://nvchad.com/docs/quickstart/install

Then carefully assess the files in this dotfiles repo for any version/compatibility changes with your new NvChad installation before pasting each one's content accordingly.
Or you can go ahead and simply clone this repo. Then replace your `~/.config/nvim` contents with it if you are sure all configurations check out.

## Set aliases in .bashrc or .zshrc

```sh

alias vim='clear && nvim'
alias nvim='~/nvim-linux64/bin/nvim'


```

## Shortcut to open a terminal with Nvim (PTYXIS terminal)

Create a custom keyboard shortcut in your Fedora settings for Nvim and add the command below:

```sh
ptyxis --new-window --working-directory=/home/oserefemhen/work -- zsh -c "nvim"
```

Customize the command above to your heart's content.

## Language servers

These are the specific configuration names for the servers you intend to use here:
https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md

For automatic installation and custom configuration (optional) place any of them you want in configs/lspconfig.lua and then run `:MasonInstallAll`.

## Svelte format on save configuration

As of Nov. 29. 2024, all you need to do is install [prettier-plugin-svelte](https://github.com/sveltejs/prettier-plugin-svelte) globally. No formatting configuration needed. You should also install and setup the Svelt LSP too.

```sh
yarn global add prettier-plugin-svelte

```

## POPULAR SHORTCUTS

- [All mapping for the Telescope file browser.](https://github.com/nvim-telescope/telescope-file-browser.nvim?tab=readme-ov-file#mappings)
- Change nvim's cwd to selected folder/file(parent) - `<C-w>/w` (Insert/normal)
- Collapse all (Nvimtree) - `W`
- Copy absolute path - `gy`
- Up (Nvimtree) - `-`
- Change working directory for Telescope and Nvimtree - ;cd <directory>CR
- Make selected Nvimtree directory the working directory - `C-]`
- Cut a line or delete a line - dd or <DELETE>
- Cut or delete a block - place your cursor at the start of the line and then press d(number of lines)ENTER
- Go to import definition - gd
- Move line up or down - alt + k or j
- Duplicate line down - Leader d (n mode)
- Undo and redo - u and ^R
- Toggle comment - Leader /
- Horizontal terminal - Leader h (q to quit) Avoid using this terminal style. Use an actual terminal tab.
- Toggle NVIM Tree - C-n
- Shortcut cheatsheet - Leader ch
- Toggle relative numbers - Leader rn
- Toggle line numbers - Leader n
- Floating file browser with the current path - sf (normal mode)
- Find word in current buffer - ;f or Leader fz (this uses Telescope).
- Find word in across current root directory - Leader fw.
- Find file in across current root directory - ;r.
- Super powers - :Telescope
- Using Telescope to see all keymaps - Leader km or :Telescope keymaps
- Lazy - Leader l
- Close out of NvChad (this prompt you to save unsaved files) - Leader q
- Close out of NvChad (this discard all unsaved changes) - Leader Q
- Close tab (buffer) - Leader X
- IN YOUR FILE BROWSER
  - h to go to the parent directory (like going cd ../)
  - c to create a new file
  - r to rename a file
  - s to select a file and m to move it
  - s to select a file and d to delete it with confirmation
- Indent multiple lines in visual mode: `>` or `<`
- Select matching tag: `%`
- Nvim file explorer (Nvimtree) shortcuts -
  https://github.com/nvim-tree/nvim-tree.lua/blob/master/doc/nvim-tree-lua.txt
  or type :h nvim-tree-highlight in Nvim
