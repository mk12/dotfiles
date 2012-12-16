Dotfiles
========

These are my humble dotfiles.

Right now they only configure:

- Vim
- Git
- Bash

Usage
-----

Executing the `link.sh` script will symlink all the dotfiles into your home directory. It will not overwrite anything, so you will have to manually delete or move dotfiles that are already there. You should only link once, and forget about it afterwards. Use `vim .bashrc` just like you used to, and just be aware that you are actually modifying the file in the folder where you cloned this repository.

Credit
------

I got the idea for this from [GitHub does dotfiles][gdd] and received inspiration from several of the respositories linked there.

[gdd]: http://dotfiles.github.com

License
-------

Copyright © 2012 Mitchell Kember

Dotfiles is available under the MIT license; see [LICENSE][] for details.

[LICENSE]: https://github.com/mk12/dotfiles/blob/master/LICENSE.md
