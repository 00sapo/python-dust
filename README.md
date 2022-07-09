# Python Dust

_Make your research reproducible effortless._

This is a simple repo for automatizing the setup of many projects.

## Why?

1. People interested in your research may not be able to code
2. Young users often don't know how to set up the dependencies to
   run your code
3. You want to use specific versions that are not available on the platform you're
   using (e.g. a server, Google Colab, Paperspace Gradient, etc.)
4. You want your specific setupalways ready at each Colab/Gradient startup
5. You want that other researchers can easily use your code


## Tutorial

### Create a new project
It should work on any Unix-like system (Linux, Mac, etc.)

* Option 1 (only Github): select the `use this template` above
* Option 2: download the zip and uncompress it in your working directory:
  * with jar:
  ```shell
  curl https://codeload.github.com/00sapo/python-dust/zip/refs/heads/main | jar xv
  mv python-dust-main/* .
  rm -r python-dust-main
  ```
  * with unzip:
  ```shell
  curl https://codeload.github.com/00sapo/python-dust/zip/refs/heads/main -o python-dust.zip 
  unzip python-dust.zip -d .
  mv python-dust-main/* .
  rm -r python-dust-main python-dust.zip
  ```

### Install python
Now, let us install Python inside the `pyenv` directory. Simply run:
```
./install.sh 3.8.13
```
This will install python 3.8.13. Any version available from pyenv can be used.
 
The following command will guide you through the setup of the project metadata,
You should always chose a python executable that is inside the `pyenv`
directory of your project, usually the number 0.
```
./dust init
```

### Develop
Now, let's add some dependency:
```
./dust add numpy
```

Finally, execute some python code:
```
./dust run python -c "import numpy as np; print(np.random.rand())"
```

It should print a random number.

### Distribute
Assume that now you distribute your code and want that other researchers use
it. You can just create a readme saying the following:

> ## Set-up
> 1. Prepare your environment: `./install.sh 3.8.13`
> 2. Check that the path of your python is inside the `./pyenv` directory:
>    `./dust run which python`

The `./install.sh` will install all the dependencies needed, including the
correct python version.

The same will work when moving your code to Google Colab or Paperspace
Gradient, that offer you some persistent directory but don't allow you to edit
your home file persistently (they will erase them when your environment is
killed).

## How does this work?

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


## Usage

You can execute any command inside the environment by prepending it with
`./dust`. Internally, `dust` setups `pyenv` and runs the `pdm $@`. In POSIX-like
shells, `$@` means _"all the received arguments"_. So, you can give any command
to `pdm`. Some useful commands:

* `./dust init`
* `./dust add <package>`
* `./dust remove <package>`
* `./dust lock`
* `./dust sync --clean`

### `pdm` and `pip`

There are two modes of operating: one using `pdm` and one using `pip`.

While `pdm` is the default and recommended mode for now, you can optionally
turn it off by creating a file named `requirements.txt` before the
installation. Then, all the command will be executed as they are, e.g.: `./dust
pip install numpy` will install numpy in your project's python installation.

Once you have run `./install.sh <your-python-version>`, you can switch from
`pdm` to `pip` or from `pip` to `pdm`. 

**If both of them are turned on (i.e. both `__pypackages__` and
`requirements.txt` exist), `pdm` will be used.**

Of course, when using `pip`, you can redistribute your code exactly like when
using `pdm`.

In future, when `pip` will use `pyproject.toml` file by default and will use a
continuously updated lock file, it should become the default.

#### `pdm` => `pip`

To convert a project from `pdm` to `pip` mode:
* `./dust export -f requirements > requirements.txt`
* `./dust run pip uninstall pdm`

#### `pdm` <= `pip`

To convert a project from `pip` to `pdm` mode:
* `./dust pip install pdm`
* `./dust import requirements.txt`

### pyenv management and shells

You can also run any command in the `pyenv` by using the special command `fly`.
Using it, the arguments will be executed exactly like they are but inside a
shell where the project's `pyenv` is correctly set-up. For instance, at a certain point of the development, you may want to have two python versions installed and switch from one to the other:

```shell
# install a new python version
./dust fly pyenv install 3.9.1
# switch to the new python version
./dust fly pyenv local 3.9.1
# install dependencies for this new verions (in pdm mode)
./dust sync
# switch back to the previous one
./dust fly pyenv local 3.8.3
```

A similar effect is achieved by using `./dust run` in `pdm` mode or with any
command when using `pip` mode. While for `pip` mode, the effect is exactly the
same, `./dust run` in `pdm` mode is slower, because it runs through `pdm`
before of setting up `pyenv`. For instance, the following commands all achieve
the same effect:

```shell
./dust run bash # in pdm mode, slower
./dust fly bash # in pdm/pip mode, faster
./dust bash     # in pip mode
```

As in the example above, you could spawn a shell which uses your preject's
python installation. However, if your shell has some init file that conflicts
with `pyenv` (e.g. if you have `pyenv` installed in your system like me), the
above method doesn't work to spawn a shell. Instead you should use the provided
command: `./dust shell`, which spawns a new instance of your current shell.
Only fish and bash supported for now.

### virtualenv vs `__pypackages__`

If you don't want to use PEP 582 (`__pypackages__` directory) and you still
prefer using virtualenvs, just create a directory named `.venv` before of
running `./install.sh`. `pdm` will use it to put the virtualenv and run code.
Note that if you switch to `pip` mode via `requirements.txt`, you
don't need virtualenvs at all, because all the python installation is relative
to this directory.

## Uninstall

To uninstall all the directories related to your project's Python installation,
run:

`sh uninstall.sh`

This script is not tested and is not ensured that it really deletes all the
directories created by `./install.sh`.

## Test

To test this project for development purpose, use the branch `develop` and test
using the command `./test-dust ./install.sh 3.8.13`

## Why `pdm` and not X?

1. While `pip` is improving and is now able to do backtracking, it doesn't
   ensure a lock file (requirements.txt) always up-to-date, nor the ability to
   convert your code to a standalone pypi module uploadable to pypi.org 
   effortless. Moreover, version constraints are hard to setup with `pip`
2. Conda is slow and covers only a few packages, poetry and Pipenv are
   slow, pip-tools reinvent the standard

## Possible improvements

* Switch of `pip`/`pdm` mode should be done based on some file
* Python version to be installed can be taken from `.python-version`
* In `pip` mode, provide an install and uninstall command which install packages
  and updates requirements.txt or explore the support for project.toml
* In `pdm` mode, keep requirements.txt updated
* add a guide to import the project's `requirements.txt` in another project
* Add automatic check of the installation in `install.sh`

# Credits

Federico Simonetta

https://federicosimonetta.eu.org
