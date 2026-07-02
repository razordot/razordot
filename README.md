# razordot :: dotfile manager
Razordot is a razor-thin, dependencyless, cross-platform, self-updating dotfile manager.

To get started with your own razordot powered repository, create an empty repository and copy one of the razordot scripts for your preferred shell language.

Commonly `razordot.zsh` is used for macOS/Linux and `razordot.ps1` for Windows machines.

Then add folders to the repository with an install script in the chosen scripting language (ie. `install.zsh` or `install.ps1`) and reference them in your razordot script `install_folders`.

To see an example of my mono-repo setup supporting various cross-platform dotfiles, have a look at `github.com/bvoq/dotfiles`.

You will see that razordot is quite *boiler-plate heavy*. This if for good reason:

1. It makes `razordot`'s core significantly smaller and therefor easier to understand.
2. Running something so powerful like a dotfile manager normally elicits feelings of discomfort.
   `razordot` can be **fully** learnt and studied in an hour, leaving no doubts as to how it works.
3. It makes it more personalisable. There is little structure to it, and, dare I say, it's closer to a library than a program.
4. Simpler yet more boiler-heavy logic is more suitable for LLMs and larger teams.

## Philosophy & Understanding

Originally, the maintainer was a mobile developer and teacher. These professions require a lot of switching between devices and operating systems.

razordot does not require any language dependencies. Whatever scripting language your machines have, is the scripting language used for your dotfiles.
It also doesn't prescribe how to structure your folders.


Here you can get a good grasps of the 5 install phases:

| Phase | Package hook | What it is for |
| --- | --- | --- |
| 1 | `phase_1_admin_installs` | Admin-privileged installs like: Homebrew bundles/casks, AppStore apps and other system-level apps. Skipped when the user is not an admin. |
| 2 | `phase_2_user_installs` | User-level installs that do not require dotfiles yet: cloned tools, per-user package managers, and curl-based installers. |
| 3 | `phase_3_dotfiles` | Dotfile linking via `link_dotfile`, including package-owned config files and shell fragments. |
| 4 | `phase_4_post_dotfiles` | User-level setup that requires dotfiles to already be linked: plugin installs, sync commands, and tool initialization. |
| 5 | `phase_5_system_changes` | Heavy system changes that require admin privileges and may require a restart, such as macOS defaults or system-wide configuration. |

Further, you can see the numerical ordering in action.
For example, my .zshrc.d/ files are ordered numerically by the following phases:

00_safe_config.zsh
  aliases, functions, helper sources, variables safe to define even in limited/dumb contexts

10_guard.zsh
  return early for non-interactive/dumb/non-tty cases; terminal repair like stty sane

20_pre_compinit.zsh
  interactive shell behavior (setopt, bindkey, history) plus pre-compinit setup:
  fpath/FPATH additions, completion zstyles, plugins that only provide completion sources

30_compinit.zsh
  autoload -Uz compinit
  compinit

40_ishell_setup.zsh
  tool initialization after shell/completion base is ready:
  fzf, zoxide, direnv, starship, compdef, current antidote load

Package folders provide their own fragments under the same names (e.g. git/.zshrc.d/00_safe_config.zsh),
linked into ~/.zshrc.d/ with the folder name appended (e.g. 00_safe_config_git.zsh) so they sort by phase.

You can define your own naming convention, all razordot does is link them and source them in order for you.

To get started with your own razordot powered repository, just copy the self-updating razordot.zsh / razordot.ps to your repository and create your own folders.

If you like to load different folders for different machines, just copy them and enable/disable different folders.

Further, some of these folders can be used directly by you.

If you are on macOS/unix check out `razordot.zsh`

If you are on Windows check out `bootstrap.ps1`

Install using:
```
zsh razordot.zsh
```

![Alt text](xcode/xcodetheme.png?raw=true "XCode Theme")
![Alt text](terminal/terminaltheme.png?raw=true "Terminal Theme")
