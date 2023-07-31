# .dotfiles

| where        | what                                                       |
| ------------ | ---------------------------------------------------------- |
| Editor       | Visual Studio Code                                         |
| Terminal     | Alacritty + oh-my-zsh (p10k)                               |
| WM           | i3                                                         |
| Color scheme | [Nord](https://www.nordtheme.com/docs/colors-and-palettes) |

## How to link

The dotfiles are managed by using **GNU Stow**, which is a symlink manager.

To link a configuration you must run `stow` with the dotfiles which you want to link, like so:

```bash
$ stow lunarvim
```

easy, no?

# Helpful Links

- [Github ssh guide](https://docs.github.com/en/authentication/connecting-to-github-with-ssh), since Github doesn't allow password authentication anymore and I never remember how to generate a SSH key.
- [GTK Nord Theme](https://github.com/EliverLara/Nordic), that's the GTK theme I use.
- [Yay Installation guide](https://github.com/Jguer/yay), in my opinion: the best AUR helper.
- [Nordzy Icons](https://github.com/alvatip/Nordzy-icon), I use the `Nordzy` icon theme.
- [Nordzy Cursor](https://github.com/alvatip/Nordzy-cursors), I use the `Nordzy` cursor theme.
- [GTK Theme Not Applied](https://wiki.archlinux.org/title/GTK#Theme_not_applied_to_root_applications), I always forget how to apply GTK themes to root applications.