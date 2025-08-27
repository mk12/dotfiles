# Dotfiles

These are my humble dotfiles.

I actively use and update the following files:

- sh: [.profile](.profile)
- bash: [.bash_profile](.bash_profile), [.bashrc](.bashrc)
- fish: [config.fish](.config/fish/config.fish), [fish_plugins](.config/fish/fish_plugins)
- vim: [.vimrc](.vimrc)
- nvim: [init.vim](.config/nvim/init.vim)
- kitty: [kitty.conf](.config/kitty/kitty.conf), [tmux.conf](.config/kitty/tmux.conf)
- tmux: [tmux.conf](.config/tmux/tmux.conf)
- git: [config](.config/git/config), [ignore](.config/git/ignore)
- hammerspoon: [init.lua](.config/hammerspoon/init.lua)

## Usage

Run `make install` to symlink dotfiles in `$HOME`.

Run `make lint` to lint shell scripts with [ShellCheck][].

## Shell

I use [fish][] as my primary shell, but I still like to have a usable bash environment. To that end, I have my shell config set up like this:

- [config.fish](.config/fish/config.fish): Fish configuration. Sources environment variables from `.profile`. If interactive, defines functions, aliases, etc. and sources `local.fish`.
- `local.fish`: Machine-specific extension to `config.fish`.
- [fish_plugins](.config/fish/fish_plugins): Fish plugins installed by [fisher][].
- [.bash_profile](.bash_profile): Simply sources `.bashrc`.
- [.bashrc](.bashrc): Sources `.profile`. If interactive, sets bash-specific options.
- [.profile](.profile): Written in POSIX sh. This file only sets environment variables. It also sources `.local.profile`.
- `.local.profile`: Machine-specific extension to `.profile`.

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

I keep my vim and nvim config in sync.

To check the difference between them:

```sh
git diff --no-index .config/nvim/init.vim .vimrc
```

To copy changes from `init.vim` to `.vimrc`:

```sh
./patch_vimrc.sh
```

## Local files

To allow for per-machine differences, I use "local" files like `local.fish` and `local.gitconfig`. Since these are not checked into the repository, you can see them all in [.gitignore](.gitignore).

I could just create these files directly in `$HOME` rather than symlinking them, but I prefer having them in the `dotfiles` directory so that everything is in one place. For example, this is nice when opening the `dotfiles` project in an editor and browsing its files.

## Inspiration

I got the idea for this from [GitHub does dotfiles][gdd].

## License

© 2022 Mitchell Kember

Dotfiles is available under the MIT License; see [LICENSE](LICENSE.md) for details.

[fish]: https://fishshell.com
[fisher]: https://github.com/jorgebucaran/fisher
[gdd]: http://dotfiles.github.io
[ShellCheck]: https://www.shellcheck.net
