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

This repo simply allows to automatically download and install `pyenv` and `pdm`
inside your project. Nothing is installed outside of it. Moving the project
directory won't break anything. Removing the directory removes everything.

This repo turns to be useful even for project that must be run on remote
servers or platforms such as Google Colab and Paperspace Gradient, because it
allows you to install any python version on those servers in a persistent way
(you won't need to re-install everything every times the environment is
killed).

Finally, you are not obliged to use `pdm` if you do not want to. You can just create
a `requirements.txt` file to inform the installation script to avoid `pdm`, and
you're done: enjoy `pip`. You won't need virtualenvs at all, because all the python 
installation is relative to your project directory!

## Installation

It should work on any Unix-like system (Linux, Mac, etc.)

* Option 1 (only Github): select the `use this template` above
* Option 2: download the zip and uncompress it in your working directory:
  * with jar:
  ```shell
  curl https://codeload.github.com/00sapo/pyreproduce/zip/refs/heads/main | jar xv
  mv pyreproduce-main/* .
  rm -r pyreproduce-main
  ```
  * with unzip:
  ```shell
  curl https://codeload.github.com/00sapo/pyreproduce/zip/refs/heads/main -o pyreproduce.zip 
  unzip pyreproduce.zip -d .
  mv pyreproduce-main/* .
  rm -r pyreproduce-main pyreproduce.zip
  ```

## Usage

Put this in your reproducible guide:

> ## Set-up
> 1. Prepare your environment: `./install.sh`
> 2. Check that the path of your python is inside the `./pyenv` directory:
>    `./run.sh run which python`

You can execute any command inside the environment by prepending it with
`./run.sh`. Internally, `run.sh` setups `pyenv` and runs the `pdm $@`. In POSIX
shells, `$@` means _"all the received arguments"_. So, you can give any command
to `pdm`. Some useful commands:

* `./run.sh init`
* `./run.sh add <package>`
* `./run.sh remove <package>`
* `./run.sh lock`
* `./run.sh sync --clean`

You can also get a shell where `python` is binded to your version:
`./run.sh shell`. However, note that for now this will return your system
shell, not the one you are actually using (i.e. it returns the `/bin/env sh`,
not `$SHELL`, so if you're using non POSIX shells like `fish`, it can't be
returned for now).

If you don't want to use PEP 582 (`__pypackages__` directory) and you still
prefer using virtualenvs, just create a directory named `.venv` before of
running `./install.sh`. `pdm` will use it to put the virtualenv and run code.
Note that if you switch to the usage of regular `pip` via `requirements.txt`, you
don't need virtualenvs at all, because all the python installation is relative
to this directory.

### `pdm` and `pip`

You can optionally turn off `pdm` by creating a file named `requirements.txt`
before the installation. Then, all the command will be executed as they are, e.g.:
`./run.sh pip install numpy` will install numpy in your project's python 
installation.

Once you have run `./install.sh <your-python-version>`, you can switch from
`pdm` to `pip` or from `pip` to `pdm`. 

If all of them are turned on (i.e. both `__pypackages__` and `requirements.txt`
exist), `pdm` will be used.

#### `pdm` => `pip`

* `./run.sh export -f requirements > requirements.txt`
* `./run.sh run pip uninstall pdm`

#### `pdm` <= `pip`

* `./run.sh pip install pdm`
* `./run.sh import requirements.txt`

## Uninstall

To uninstall all the directories related to your project's Python installation,
run:

`sh uninstall.sh`

This script is not tested and is not ensured that it really deletes all the
directories created by `./install.sh`.

## Test

To test this project for development purpose, use the branch `develop` and test
using the command `./test-pyreproduce.sh ./install.sh 3.8.13`

# Credits

Federico Simonetta

https://federicosimonetta.eu.org
