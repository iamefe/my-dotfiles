# Notes

## For new Nvchad installation
Install Neovim this from https://github.com/neovim/neovim

Then install NvChad this way. 
```bash
git clone https://github.com/NvChad/starter ~/.config/nvim && nvim
```
After which you should follow the remaining instructions at
https://nvchad.com/docs/quickstart/install

Then carefully assess the files in this dotfiles repo for any version/compatibility changes with your new NvChad installation before pasting each one's content accordingly.

## Terminal productivity enhancements

https://www.youtube.com/shorts/K1FxGIG_lcA

## Shortcuts

### TMUX

tmux new -s nameofsession
tmux detach
tmux attach -t nameofsession

Custom prefix
C-z

Warning:
`exit` deletes your session unlike `detach` which only takes you out of the session but saves it for you to later retach to.

See all sessions
C-z then s

Reloading configurations
:source-file <locationoftmuxfile>
or C-z then r

Toggle maximize pane
C-z the m

New TMUX window
C-z then c

A TMUX session can have multiple windows and each window can have multiple panes

Rename a window
C-z then ,

Navigate between windows
C-z then window number eg 0
or
C-z then n or p

Ctrl+z :kill-session – kill the active session, all its windows and panes.
Ctrl+z :kill-window or Ctrl+z & – kill the active window and all panes within it.
Ctrl+z :kill-pane or Ctrl+z x – kill the active pane.

See all sessions and their windows and panes
C-z then w

Rename a session
C-z + $

Enable vi mode
C-z then [

Selection mode in vi mode
v

Exit vi mode
C-c

Navigating in vi mode
C-k to go up
C-j to go down
C-u to go up half a page
C-d to go down half a page

## NVCHAD

Install Neovim
https://github.com/neovim/neovim/releases

I prefer Tarball. Delete the previous extract located in the home directory and extract the new one there.

Set aliases in .bashrc
alias vim='clear && nvim'
alias nvim='~/nvim-linux64/bin/nvim'
