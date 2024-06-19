# Notes

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
Cf-z + $

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
I prefer Tarball. Delete the previous extract located in the home directory and extra the new one there.

Set aliases in .bashrc
alias vim='clear && nvim'
alias nvim='~/nvim-linux64/bin/nvim'
