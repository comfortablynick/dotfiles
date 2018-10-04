#!/usr/bin/env python3
"""Universal script to execute vim sync.

Runs in bash, fish, and xonsh.
"""
from subprocess import run


# TODO: Consider adding switches for updating of vim-plug and plugins
def sync():
    # Vim
    print('Attempting to update Vim plugins...')
    try:
        run(['vim', '+PlugInstall', '+qall'])
    except FileNotFoundError:
        print('Vim not found!')
    else:
        print('Vim plugins updated. Updating remote plugins...')
        run(['vim', '+UpdateRemotePlugins', '+qall'])
        print('Vim updates complete.')

    # Neovim
    print('Attempting to update Neovim plugins ...')
    try:
        run(['nvim', '+PlugInstall', '+qall'])
    except FileNotFoundError:
        print('Neovim not found!')
    else:
        print('Neovim plugins updated. Updating remote plugins ...')
        # Open nvim with typescript file to force start of ts-server
        run(['nvim', 't.ts', '+UpdateRemotePlugins', '+qall'])
        print('Neovim updates complete.')

    print('Vim/Neovim plugin sync complete')


if __name__ == '__main__':
    sync()
