# razordot :: dotfile manager / dotfile management library 🪒
Razordot is a razor-thin, single-file, dependency-less, cross-platform, self-updating dotfile manager.

To get started with your own razordot powered repository, create an empty repository and copy one of the razordot scripts for your preferred shell language.

Commonly `razordot.zsh` is used for macOS/Linux, `razordot.ps1` for Windows machines and `razordot.sh` for other systems such as Alpine Linux.

Then add folders to the repository with an install script in the chosen scripting language (ie. `install.zsh` or `install.ps1`) and reference them in your razordot script `install_folders`.

To see an example of my mono-repo setup supporting various cross-platform dotfiles, have a look at `github.com/bvoq/dotfiles`.

You will see that razordot is quite *boiler-plate heavy*. This if for good reason:

1. It makes `razordot`'s core significantly smaller and therefor easier to understand.
2. Running something so powerful like a dotfile manager normally elicits feelings of discomfort.
   `razordot` can be **fully** learnt and studied in an hour, leaving no doubts as to how it works.
3. It makes it more personalisable. There is little structure to it, and, dare I say, it's closer to a library than a program.
4. Simpler yet more boiler-heavy logic is more suitable for LLMs and larger teams.

## Philosophy

Originally, the maintainer had a profession that required frequent switching between devices and operating systems. This solution grew organically out of their need to share not only tools but also configurations across machines and operating systems.

razordot does not have any dependencies besides the scripting language your machine uses. It also doesn't prescribe how to split your setup into chunks. You can do anything from per-device setups to cross-OS setups, from per-package folders to workflow folder setups.

The only thing it prescribes are the build phases, of which copying over dotfiles is just one phase.

## install scripts and their phases

razordot works by first calling for each folder phase 1 in their install script. After phase 1 is completed for all folders it moves to phase 2 and so on.

This is to tolerate cross-**cut**ting concerns. For example if the vscode folder installs vscode in phase 1, you can still install vscode plugins from other folders in phases 2, 3 or 4.

It is not checked what is done in what phase, however the conventions around the phases is the following:

| Phase | Package hook | Runs even as non-admin user | What it is for |
| --- | --- | --- | --- |
| 1 | `phase_1_admin_installs` | ❌ | Admin-privileged installs like: Homebrew bundles/casks, AppStore apps and other system-level apps. Skipped when the user is not an admin. |
| 2 | `phase_2_user_installs` | ✅ | User-level installs that do not require dotfiles yet: cloned tools, per-user package managers, and curl-based installers. |
| 3 | `phase_3_dotfiles` | ✅ | Dotfile linking via `link_dotfile`, including package-owned config files and shell fragments. |
| 4 | `phase_4_post_dotfiles` | ✅ | User-level setup that requires dotfiles to already be linked: plugin installs, sync commands, and tool initialization. |
| 5 | `phase_5_system_changes` | ❌ | Heavy system changes that require admin privileges and may require a restart, such as macOS defaults or system-wide configuration. |

## scripting language specific splits

Further, for each scripting language you use, there comes a bit of machinery to split dotfiles for that scripting language.
In the case of `razordot.zsh` it creates a `~/.zshrc` and `~/.zshenv` file which sources files from `~/.zshrc.d/*.zsh` and `~/.zshenv.d/*` respectively.

Further, these are sourced in numerical order. This allows for cross-**cut**ting concerns between folders in your setup.

In the maintainers repo .zshrc.d/ files have been ordered numerically by the following phases:

00_safe_config.zsh
  aliases, functions, helper sources, variables safe to define even in limited/dumb contexts

10_guard.zsh
  return early for non-interactive/dumb/non-tty cases and terminal repair commands like stty sane

20_pre_compinit.zsh
  interactive shell behavior (setopt, bindkey, history) plus pre-compinit setup:
  fpath/FPATH additions, completion zstyles, plugins that only provide completion sources

30_compinit.zsh
  autoload -Uz compinit
  compinit

40_ishell_setup.zsh
  tool initialization after shell/completion base is ready:
  fzf, zoxide, direnv, starship, compdef, current antidote load

You are free to define your own naming convention, all razordot does is link them and source them in order for you.

## install functions

Each of the `razordot` scripts come with handy functions to make writing your install scripts easier.

### universal functions

### .zsh functions

For `.zsh` we have:

- `install_brewfile <folder/Brewfile>` :: This function should only be called in phase1. It installs the specified Brewfile but also remembers it for the end of phase1. At the end of phase1, the user is prompted whether or not to purge any brew packages, casks or mas that have been installed outside of this razordot configuration. If you don't want to be prompted, you can also set the decision using `PURGE_BREW_AFTER_INSTALL` and set it to 0 for disabled and 1 for enabled.

If you are on Windows check out `bootstrap.ps1`


### Secret management
The easiest way to manage secrets is through gopass, bitwarden-cli, dopppler or another secret manager and inject them during your install scripts.
Another easy way, is to add private folders by adding them to `.gitignore` and syncing them outside of github.
This would be necessary to install your secrets manager for example.
