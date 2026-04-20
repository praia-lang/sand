# sand

Package manager for [Praia](https://github.com/praia-lang/praia). Written in Praia.

Grains (Praia modules) are installed from Git repositories into your project's `ext_grains/` directory by default.

## Install

```bash
git clone https://github.com/praia-lang/sand.git ~/.praia/sand
```

Then add it to your shell:

```bash
# symlink
ln -s ~/.praia/sand/sand.sh /usr/local/bin/sand

# or alias in ~/.bashrc / ~/.zshrc
alias sand='~/.praia/sand/sand.sh'
```

Requires `praia` and `git` on your PATH.

## Usage

```
sand init                      Create a grain.yaml in the current directory
sand install                   Install all dependencies from grain.yaml
sand install <url>             Install a grain locally (into ext_grains/)
sand install --global <url>    Install a grain globally (into ~/.praia/grains/)
sand remove <name>             Remove a locally installed grain
sand remove --global <name>    Remove a globally installed grain
sand list                      List locally installed grains
sand list --global             List globally installed grains
sand info <name>               Show info about an installed grain
sand --version                 Print version
sand help                      Show help
```

## Installing grains

```bash
# install locally (into ext_grains/)
sand install github.com/user/mygrain

# pinned to a version (git tag)
sand install github.com/user/mygrain@0.2.0

# from any git URL
sand install https://gitlab.com/user/mygrain.git

# install globally (shared across all projects)
sand install --global github.com/user/mygrain
```

Then use it in your Praia code:

```
use 'mygrain'

mygrain.doSomething()
```

Grain names with hyphens need an alias:

```
use 'my-grain' as myGrain

myGrain.doSomething()
```

## Local vs global

By default, grains are installed **locally** into `ext_grains/` in your project root, with a `sand-lock.yaml` lock file alongside your `grain.yaml`. This means each project has its own isolated dependencies.

Use `--global` (or `-g`) to install into `~/.praia/grains/` instead, making the grain available to all projects.

Praia resolves grains in this order:

1. `ext_grains/` (local, from your project)
2. `grains/` (bundled with your project)
3. `~/.praia/grains/` (global)

## Project manifest

Run `sand init` to create a `grain.yaml`:

```yaml
name: my-project
version: 0.1.0
description: A short description
author: username
license: MIT
main: index.praia
dependencies:
  router: github.com/user/router@0.1.0
  utils: github.com/user/utils
```

When you `sand install <url>` inside a project with a `grain.yaml`, the dependency is automatically added. Running `sand install` with no arguments installs everything listed in `dependencies`.

## Publishing a grain

A grain is a Git repository with a `grain.yaml` and Praia source files.

Single-file grain:

```
mygrain/
  grain.yaml
  index.praia
```

Multi-file grain:

```
mygrain/
  grain.yaml
  index.praia      <- entry point
  helpers.praia
  utils.praia
```

The `main` field in `grain.yaml` specifies the entry file (defaults to `index.praia`). The entire directory is copied on install, so relative imports between files work.

Tag releases with git tags for versioned installs:

```bash
git tag 0.1.0
git push origin 0.1.0
```

## How it works

- `sand install` clones the repo to a temp directory and copies the entire grain directory into `ext_grains/<name>/` (or `~/.praia/grains/<name>/` with `--global`)
- Installed grains are tracked in `sand-lock.yaml` (local) or `~/.praia/grains/.sand-lock.yaml` (global)
- Praia resolves `use 'name'` by looking for `ext_grains/<name>/` and reading its `grain.yaml` to find the entry point
- Multi-file grains work because relative imports (`use "./helpers"`) resolve from the grain's own directory
- Transitive dependencies listed in a grain's `grain.yaml` are installed automatically
