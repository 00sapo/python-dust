# Reproducible Python

This is a simple repo for automatizing the setup of many projects.

By cloning this repo in your project - e.g. as a git module - you provides the
user and yourself with an easy way to setup python and its dependencies in the
exact way as you work, so that your code is always easily reproducible.

This approach leverages two wonderful tools:

* [`pdm`](https://github.com/pdm-project/pdm) which is able to efficiently
  solve python dependencies and can store them in a directory named
  `__pypackages__`, according to PEP 582, without even using virtualenvs. It's
  like `poetry`, but better.

* [`pyenv`](https://github.com/pyenv/pyenv) which can manage any python version
  on the earth (or almost)

These tools simply allow to automatically download and install `pyenv` and
`pdm` inside this repo. Nothing is installed outside. Moving the directory
won't break anything. Removing the directory removes everything.

This repo is also good for project that must be run on remote servers or
platforms such as Google Colab and Paperspace Gradient, because it allows you
to install any python version on those servers in a persistent way (you won't
need to re-install everything every times the environment is killed).

## Installation

It should work on any Unix-like system (Linux, Mac, etc.)

* Option 1 (only Github): select the `use this template` above
* Option 2: download the zip and uncompress it in your working directory:
  * with jar: `curl
  https://github.com/00sapo/pyreproduce/archive/refs/heads/main.zip
  | jar xv`
  * with unzip:
  ```shell
  curl https://github.com/00sapo/pyreproduce/archive/refs/heads/main.zip -o pyreproduce.zip 
  unzip pyreproduce.zip .
  rm pyreproduce.zip
  ```

## Usage

Put this in your reproducible guide:

> 1. Prepare your environment: `./install.sh`
> 2. Test your environment: `./run.sh python -c "import sys; print(sys.version)"`

You can execute any command inside the environment by prepending it with
`./run.sh`. Internally, `run.sh` setups `pyenv` and runs the `pdm $@`. In POSIX
shells, `$@` means _"all the received arguments"_. So, you can give any command
to `pdm`.

You can also get a shell with `pyenv` setup with the special command `./run.sh
shell`. However, note that for now this will return your system shell, not the
one you are actually using (i.e. it returns the `/bin/env sh`, not `$SHELL`, so
if you're using non POSIX shells like `fish`, it can't be returned for now).

If you don't want to use PEP 582 (`__pypackages__`) directory and you still
prefer using virtualenvs, just create a directory named `.venv` before of
running `./install.sh`. `pdm` will use it to put the virtualenv.

## Uninstall

`./uninstall.sh`

# Credits

Federico Simonetta

https://federicosimonetta.eu.org
