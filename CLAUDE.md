# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repository is

This is Nick's personal dotfiles repo, checked out **directly as `$HOME`** (the git worktree root is `/Users/nick`, i.e. this repo *is* the home directory). Almost everything under `$HOME` is untracked — the root `.gitignore` and `.config/.gitignore` explicitly exclude data dirs, caches, plugin managers' download dirs, and machine-specific state (`/Library`, `/Downloads`, `/.cache`, `/.asdf`, `/.cargo`, `/.rustup`, `/go`, `/git`, etc.). Only intentionally-managed config lives in git. When exploring "the codebase," assume most sibling files/directories in `$HOME` are irrelevant noise, not part of this project — check `.gitignore` before assuming a new top-level dir should be tracked.

Because the repo root is `$HOME`, avoid destructive git operations here more carefully than usual (e.g. `git clean -fdx`, broad `git add -A`) — they can touch real personal files outside the intentionally-tracked set. Prefer adding specific paths.

## Repository layout

- **`.config/`** — `XDG_CONFIG_HOME`. Holds per-application configuration; one subdirectory per tool (`nvim`, `zsh`, `fish`, `bash`, `tmux`, `git`, `ripgrep`, `starship.toml`, etc.). This is where most editing happens.
- **`bin/`** — personal shell scripts/utilities on `$PATH` (no build step; plain executable scripts, mostly POSIX sh/bash and one Python script).
- **`.ansible/`** — provisioning/bootstrap automation for setting up a new machine (see below).
- **`.zshenv`** — the only zsh file guaranteed to load in every context; sets up `XDG_*` vars and points `ZDOTDIR` at `.config/zsh`.
- Root-level dotfiles (`.bashrc`, `.bash_profile`, `.vimrc`, `.muttrc`, etc.) — configs for tools that don't respect XDG base dirs.

## Shell configuration architecture

zsh is the primary interactive shell; fish and bash are also fully configured. All three follow the same internal convention under their `.config/<shell>/` directory:

- `conf.d/*.{zsh,sh,fish}` — small, independently-sourced config snippets, loaded in a loop from the shell rc file (see the `for config (...)` loops in `.config/zsh/.zshrc`).
- `functions/` — one function per file, autoloaded (zsh) or picked up by the shell's function-loading convention.
- `completions/` — custom/vendored completion scripts.
- `.config/shell/` holds snippets and functions shared across *all* POSIX-ish shells (bash+zsh), sourced via `sh_source`/`conf.d` in addition to the shell-specific ones.

`.config/zsh/.zshrc` is the canonical place to see the full load order: env setup → shell options/history/keybindings → plugin manager (zinit) → theme (powerlevel10k) → source `shell/conf.d/*.sh` then `zsh/conf.d/*.zsh` → set up `fpath`/autoload functions → finalize `$PATH`.

### Single source of truth for env vars/aliases: `bin/parse_env`

Environment variables, `$PATH` entries, aliases, and abbreviations are declared once in a TOML file (schema demonstrated in `test.toml` at repo root — tables `[[path]]`, `[[env]]`, `[[abbr]]`, `[[alias]]`, each with optional `shell`, `host`, `if`, `eval`, `quote`, `desc` keys) and rendered into shell-specific syntax by `bin/parse_env` (a Python 3 script; needs `rtoml` or `tomlkit`). Support shells: `fish`, `bash`, `zsh`, `nu`. When adding a new env var/alias/path that should exist across shells, edit the TOML source and regenerate rather than duplicating the entry in each shell's rc file.

Run the script's own test:
```sh
python3 bin/parse_env -s fish < test.toml   # preview generated fish syntax
cd bin/test && python3 test_parse_env.py    # run the one unit test (invokes `parse_env` from $PATH)
```

## Neovim configuration

`.config/nvim/init.lua` is the entry point. It disables unused built-in plugins/providers, then loads `lua/config/lazy` (bootstraps the `lazy.nvim` plugin manager — lockfile at `.config/nvim/lazy-lock.json`), `lua/nvim`, and `lua/globals`. Filetype-specific settings live under `after/ftplugin/*.{vim,lua}` (one file per filetype). `.projections.json` defines file-type mappings for alternate-file navigation (`ftplugin/*.vim` ↔ `plugin/*.vim` ↔ `lua/*.lua`, etc.) used by projectionist-style plugins.

## tmux configuration

`.config/tmux/tmux.conf` is the single config file (theme split out into `tmux.theme.conf`, sourced conditionally if present; status-bar helper scripts `_cputemp`, `_loadavg`, `_memusage`, `_sysusage`, `_uptime`, `_weather` live alongside it). Notable, non-default behavior to be aware of when editing:

- Prefix is `C-a`, not the tmux default `C-b`.
- Vi-style pane navigation is overloaded onto plain `C-h/j/k/l` (no prefix) via the `is_vim` shell check — these forward the keystroke to Neovim when the active pane is running vim, otherwise they move tmux panes. Same pattern for `M-h/j/k/l` (resize) and copy-mode bindings. Relies on the `vim-tmux-navigator` vim plugin on the Neovim side.
- `mode-keys vi` with manual vi-copy/copy-mode-vi bindings for selection (`v`), rectangle-toggle (`C-v`), and yank (`y`) — written defensively (`run -b ... || true`) to support both old (`vi-copy`) and new (`copy-mode-vi`) tmux key tables across versions.
- `M-f` toggles a floating popup session (name `floating`) via `tmux popup`; `!`/`@` break the current pane into/out of that floating session. These rely on the `@last_session_name` custom option to know where to send the pane back.
- `F12` toggles a "remote/nested session" mode (moves status bar to top, clears prefix and key-table) so a nested tmux session's keybindings can pass through to the outer one.
- Plugins are managed by **TPM** (`tmux-plugins/tpm`, auto-cloned to `~/.tmux/plugins/tpm` on first run — note this path is *not* XDG-relative). Installed plugins: `tmux-yank`, `tmux-mem-cpu-load`. `run '~/.tmux/plugins/tpm/tpm'` must stay the last line in the file per TPM's convention.
- Reload config in-session with the bound key `prefix R` (`bind-key R source-file ...`).

## git configuration

`.config/git/config` (global gitconfig) and `.config/git/ignore` (global gitignore, pointed to implicitly via XDG `$XDG_CONFIG_HOME/git/config`/`ignore`) are the canonical git config — not `~/.gitconfig`.

- **Credential helper is custom**: `credential.helper = op` resolves to `bin/git-credential-op`, a hand-written helper that shells out to the 1Password CLI (`op item get --reveal --fields label=username,password "git_<host>"`) rather than using 1Password's built-in git integration. It requires `op whoami` to succeed (i.e. being signed in to the 1Password CLI) and expects a 1Password item literally named `git_<host>` per remote host. When debugging git auth failures, check this script and 1Password CLI session state first.
- **`git` itself is aliased to `hub`** in shell config (`[[alias]] key = 'git' val = 'hub'` in `test.toml`/`env.toml`, bash/zsh only) — so interactive shells get GitHub-flavored extras (e.g. `git create`, `git browse`) transparently; `hub.protocol = https` is set accordingly.
- **Diffing** goes through `delta` (`core.pager = delta`) with a custom `[delta "pretty"]`/`[delta "side-by-side"]` theme (zenburn syntax theme, line numbers on, file headers omitted).
- `merge.tool = vimdiff` with `conflictstyle = diff3` and a custom 4-way `mergetool "vimdiff"` command that opens local/base/remote/merged in Neovim splits.
- `pull.rebase = false` (merge, not rebase, on `git pull`); `init.defaultBranch = main`.
- The global ignore (`.config/git/ignore`) is broad, OS/tool-level noise (`.DS_Store`, `__pycache__/`, `.idea/`, `*.log`, etc.) — project-specific ignores still belong in each project's own `.gitignore`, not here. Note it also excludes `**/.claude/settings.local.json` globally.

## Machine provisioning via Ansible (`.ansible/`)

`.ansible/site.yml` is the master playbook: it imports one playbook per tool from `.ansible/playbooks/` (e.g. `nvim.yml`, `rust.yml`, `tmux.yml`, `zoxide.yml`) to install/build that tool on a fresh machine. Each tool typically has a matching role under `.ansible/roles/<tool>/` (`defaults/`, `tasks/`, and often `tasks/<Distro>.yml` for OS-specific logic — Darwin/Archlinux/Debian). Inventory (`.ansible/hosts`) lists real hosts grouped by `dev`/`www`/`linux`/`macos`/`rpi`. `bin/ansible_role <name>` scaffolds a new minimal role (tasks + defaults only, no meta/handlers/tests boilerplate).

To provision/update a host:
```sh
ansible-playbook .ansible/site.yml -K            # full provision
ansible-playbook .ansible/playbooks/<tool>.yml -K  # single tool
```

The `dotfiles` role (`.ansible/roles/dotfiles/`) is how this repo itself gets cloned onto a new machine (`git clone` into `$HOME`) — it's the bootstrap entry point, run before other roles matter.

## Conventions to preserve

- Keep the per-shell `conf.d`/`functions`/`completions` triad symmetric across `zsh`/`fish`/`bash`/`shell` when adding new snippets — pick the most shell-specific location that applies (shared logic → `.config/shell/`, shell-specific → `.config/<shell>/`).
- New tools that need PATH/env/alias entries go through the `env.toml` → `parse_env` pipeline, not directly into `.zshrc`/`config.fish`/`.bashrc`.
- New machine-bootstrap steps become an Ansible role + playbook import in `.ansible/site.yml`, following the existing `defaults/`, `tasks/main.yml`, `tasks/<Distro>.yml` role shape.
- Before adding a new top-level `.config/<tool>` directory (or other new tracked path anywhere under `$HOME`), check whether it needs entries in `.gitignore`/`.config/.gitignore` for generated state (caches, lockfiles, history, credentials) the same way existing tools do.
