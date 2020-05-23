# Dotfiles

These are my humble dotfiles.

I actively use and update the following files:

- sh: [.profile](.profile)
- bash: [.bash_profile](.bash_profile), [.bashrc](.bashrc)
- fish: [config.fish](.config/fish/config.fish), [fishfile](.config/fish/fishfile)
- vim: [.vimrc](.vimrc)
- nvim: [init.vim](.config/nvim/init.vim)
- kitty: [kitty.conf](.config/kitty/kitty.conf), [tmux.conf](.config/kitty/tmux.conf)
- tmux: [.tmux.conf](.tmux.conf)
- git: [.gitconfig](.gitconfig), [.gitignore](.gitignore)
- ledger: [.ledgerrc](.ledgerrc)
- hammerspoon: [init.lua](.hammerspoon/init.lua)

## Usage

Run `make install` to symlink dotfiles in `$HOME`. It will prompt `y/N` for confirmation for each file.

Run `make lint` to run lint shell scripts with [ShellCheck][].

## Shell

I use [fish][] as my primary shell, but I still like to have a usable bash environment. To that end, I have my shell config set up like this:

- [config.fish](.config/fish/config.fish): Fish configuration. Sources `.profile` using [fenv][]. If interactive, defines functions, aliases, etc. and sources `local.fish`.
- `local.fish`: Machine-specific extension to `config.fish`. Not checked in, but stored in the repository directory and symlinked like the rest.
- [fishfile](.config/fish/fishfile): Fish plugins installed by [fisher][].
- [.bash_profile](.bash_profile): Simply sources `.bashrc`.
- [.bashrc](.bashrc): Sources `.profile`. If interactive, sets bash-specific options.
- [.profile](.profile): Written in POSIX sh. This file only sets environment variables. It also sources `.profile.local`.
- `.profile.local`: Machine-specific extension to `.profile`. Not checked in, but stored in the repository directory and symlinked like the rest.

Here are the files sourced  for (non)login and (non)interactive shells, assuming `sh` is `bash` invoked as `sh`, with parentheses for files that exit early because the shell is non-interactive:

| Shell | Neither | `-l`  | `-i` | `-il` |
| ----- | ------- | ----- | ---- | ----- |
| sh    |         | P     |      | P     |
| bash  |         | B(R)P | RP   | BRP   |
| fish  | (F)P    | (F)P  | FP   | FP    |

Legend:

| Letter | File            |
| ------ | --------------- |
| P      | `.profile`      |
| B      | `.bash_profile` |
| R      | `.bashrc`       |
| F      | `config.fish`   |

## Vim

I keep my Vim and Neovim config in sync.

To check the difference between them:

```sh
git diff --no-index .config/nvim/init.vim .vimrc
```

To copy changes from `init.vim` to `.vimrc`:

```sh
./patch_vimrc.sh
```

## Credit

I got the idea for this from [GitHub does dotfiles][gdd] and received inspiration from several of the repositories linked there.

## License

© 2020 Mitchell Kember

Dotfiles is available under the MIT License; see [LICENSE](LICENSE.md) for details.

[ShellCheck]: https://www.shellcheck.net
[fish]: https://fishshell.com
[fenv]: https://github.com/oh-my-fish/plugin-foreign-env
[fisher]: https://github.com/jorgebucaran/fisher
[gdd]: http://dotfiles.github.com
