# Python Dust

_Make your research reproducible effortless._

This is an interface to [pyenv](https://github.com/pyenv/pyenv) and
[pdm](https://github.com/pdm-project/pdm) to allow fully-isolated python environments
specifically designed with scientific research and re-usability.

You will get projects that are:
* installable by newbies with a single command
* installable via `pip git+https://etc.etc.` (thus indipendently from the package
  manager)
* completely relocatable (including the python binary)
* easy to maintain even with complex dependencies
* accelerated by the INTEL python libraries (as anaconda)

## Why?

1. People interested in your research may not be able to code
2. Young users often don't know how to set up the dependencies to
   run your code
3. You want to use specific versions that are not available on the platform you're
   using (e.g. a server, Google Colab, Paperspace Gradient, etc.)
4. You want your specific setupalways ready at each Colab/Gradient startup
5. You want that other researchers can easily use your code

## TLDR

* `./install`: install Python 3.9.16 in a subdirectory of your project
* `./dust add numpy scipy ipython`: install numpy, scipy, and ipython as dependencies
  from the INTEL repositories on anaconda
* `./dust shell`: run a shell with the python version set up
* `./dust exec vscode`: run a command (`nvim`) with the python version set up
* another user `./install`: install Python 3.8.13, numpy, scipy, and ipython all in your project directory
* another user `pip install git+https://your-repo-here.com/name`: install this package
  in its dependencies
* `./dust pdm publish`: publish to PyPI

## Tutorial

### Create a new project
It should work on any Unix-like system (Linux, Mac, etc.)

* Option 1 (only Github): select the `use this template` above
* Option 2: clone and deinit (or set your custom git url)
  ```
  git clone https://github.com/00sapo/pyenv <your-dir>
  rm -rf <your-dir>/.git*
  ```

### Install python
Now, let us install Python inside the `pyenv` directory. Simply run:
```
./install.sh 3.8.13
```
This will install python 3.8.13. Any version available from pyenv can be used. Use
`./install.sh list` to list them out.
 
During the installation, `pdm` will guide you through the setup of the project
metadata.

Moreover, to allow users to install the package, we will answer "yes" when
`pdm` ask us if we want to publish the project as a pip package. You if you
answer "no", you can still manually add your project name and version in the
`pyproject.toml` file.

After the installation, a check is performed. It should say "OK!".

### Develop
Now, let's add some dependency:
```
./dust add numpy
```

Finally, execute some python code:
```
./dust -c "import numpy as np; print(np.random.rand())"
```

It should print a random number.
In general, `./dust` replaces your `python` command. However, when the arguments are
`add`, `remove`, `update`, or `pdm`, it behaves differently and resorts to use `pdm`.
Other special arguments are `exec`, that is used to launch external commands with the
python version set-up, and `shell`, which spawns a shell with your python environment
set up.

### Distribute
Assume that now you distribute your code and want that other researchers use
it. You can just create a readme saying the following:

> ### Set-up to reproduce results
> Simply run: `./install.sh` from the repo root directory
>
> ### Install this repo to use it in your code
>
>     # with pip
>     pip install git+ssh://git@github.com/<user>/<project>.git
>

The `./install.sh` will install all the dependencies needed, including the
correct python version.

The same will work when moving your code to Google Colab or Paperspace
Gradient, that offer you some persistent directory but don't allow you to edit
your home file persistently (they will erase them when your environment is
killed).

## Usage

Your interface to the Python installation is `./dust`. Internally, `dust`
setups `pyenv` and runs `pyenv exec python $@`. In POSIX-like shells, `$@` means
_"all the received arguments"_. So, you can give any command to `python`. 

### Managing dependencies

`python-dust` uses `pdm` for interacting with the `pyproject.toml` file.
`pyproject.toml` is a new standard that allows to maintain project more easily.
`pip` supports `pyprojects.toml` when installing packages, but it doesn't help you to
edit it. `pdm`, instead, allows you to automatically set the version contraints on your
dependencies, easing the work for you and for other developers that want to use your
code.

For this reason, there are 4 special commands to interact with `pdm`:
1. `./dust add`: this adds packages to `pyproject.toml` and accepts all options as [`pdm add`](https://pdm.fming.dev/latest/usage/cli_reference/#exec-0--add)
2. `./dust remove`: this removes packages to `pyproject.toml` and behaves like [`pdm
   remove`](https://pdm.fming.dev/latest/usage/cli_reference/#exec-0--remove_1)
3. `./dust update`: this updates the dependencies as [`pdm
   update`](https://pdm.fming.dev/latest/usage/cli_reference/#exec-0--update_2)
4. `./dust pdm`: this allows to interact with pdm and give it any command

Note that the above 3 commands `add`, `remove`, and `update` will only change the
`pyproject.toml` file using pdm. However, dependencies are then exported to
`requirements.txt` file and installed using `pip`. This is done to avoid the overhead of
virtualenvs, that are not so much useful now, since we are using a fully isolated python
installation.

As a consequence, you should never use `./dust pdm sync`, because it would install
dependencies that will never be used.

#### Using `pip` directly

You can also use `pip` directly, but it is discouraged. The reason is that if you use
`pip`, we can easily update the `requirements.txt` file, but not the `pyproject.toml`
file. Specifically, the `pyproject.toml` file will become a long list of dependencies
(including the dependences of your dependencies) that is basically meaningless and is
the exact reason why people use `pdm`, `poetry`, and similar.

To use pip directly, just run something like:
```
./dust -m pip install numpy
```

This may come useful for you if you want to provide special arguments for a specific
package, e.g. `./dust -m pip install --force-reinstall git+https://your-get-repo.com/@commithash`.

#### Syncing

Imagine you have edited the `pyproject.toml` file by hand. Now you need to install the
new dependencies. You can use `./dust sync` for this.

Note that `./dust sync` is different from `pdm sync`, because `pdm` tries to install
packages in a virtualenv or in a `__pypackages__` directory, while `dust` install them
in the root of the python installation via `pip`. Specifically, `./dust sync` will
export the `pyproject.toml` to `requirements.txt` and then it will install it via
`pip`.

You can give any option that will then be used when installing via `pip`, e.g. `./dust
sync --force-reinstall` will reinstall all the dependencies.

### External commands and multiple python versions

You can also run any command in the `pyenv` by using the special command `exec`.
Using it, the arguments will be executed exactly like they are but inside a
shell where the project's `pyenv` is correctly set-up. For instance, at a
certain point of the development, you may want to have two python versions
installed and switch from one to the other:

```shell
# install a new python version
./dust exec pyenv install 3.9.1
# switch to the new python version
./dust exec pyenv local 3.9.1
# install dependencies for this new verions (in pdm mode)
./dust update
# switch back to the previous one
./dust exec pyenv local 3.8.3
./dust update
```

### Shells

As in the example above, you could spawn a shell which uses your project's
python installation:
```
./dust exec bash
```

However, if your shell has some init file that conflicts with `pyenv` (e.g. if you have
`pyenv` installed in your system like me), the above method doesn't work to spawn a
shell. Instead you should use the provided command: `./dust shell`, which spawns a new
instance of your current shell. Note, that if you install packages inside a spawn shell
without using `dust`, the `requirements.txt` won't be automatically updated soon, but
only when you run the `exit` command.

Only fish and bash supported for now.

### Make `pdm` skip resolution dependency

Sometimes it is useful to just install a package, without resolution dependency.
In `pdm`, read the related [documentation](https://pdm.fming.dev/latest/usage/dependency/#solve-the-locking-failure).

In short, you should put something like this in your `pyproject.toml` file.

```toml
[tool.pdm.overrides]
asgiref = "3.2.10"  # exact version
urllib3 = ">=1.26.2"  # version range
pytz = "file:///${PROJECT_ROOT}/pytz-2020.9-py3-none-any.whl"  # absolute URL
fairseq = "git+https://github.com/pytorch/fairseq@336942734c85791a90baa373c212d27e7c722662"  # git url
```

### Virtualenvs

You don't need virtualenvs at all, because all the python installation is relative
to this directory. However, to keep compatibility with other softwares, `python-dust`
creates a symbolic link to the internal `pyenv` virtualenv.

### Uninstall

To uninstall all the directories related to your project's Python installation,
run:

`sh ./pyenv/uninstall.sh`

This script is not tested and is not ensured that it really deletes all the
directories created by `./install.sh`.

## List of commands

#### `./install.sh`

| Arguments       | Effect                                                                                        |
|-----------------|-----------------------------------------------------------------------------------------------|
| No arguments    | Install python version from `.python-version` file or the default one (3.9.16), and support for scientific Intel packages from Anaconda servers (numpy, scipy, sklearn, etc.) |
| `list`          | List available versions from `pyenv`                                                          |
| `<any-version>` | Install version `<any-version>`, e.g. `3.8.9`                                                |

#### `./dust`

| Arguments       | Effect                                                                                        |
|-----------------|-----------------------------------------------------------------------------------------------|
| `add <package>` | add a package (with possible version contraint, see `pdm` docs) |
| `remove <package>` |  remove a package |
| `update` | update dependencies (see `pdm` docs) |
| `pdm <command>` | execute any `pdm` command |
| `sync` | export `pyproject.toml` into a `requirements.txt` and then install using `pip` |
| `exec <command>` | exec any command using the virtualenv set up by `pyenv` |
| `shell` | return a shell (`bash` or `fish`, depending on your current one) inside the virtualenv |
| `setup_intel` | set up the INTEL mirrors from anaconda so that scientific packages
such numpy, scipy, and sklearn benefits from accelerated libraries |
| anything else | passed as argument to `python`, e.g. `./dust -m http.server 8000` or `./dust myscript.py`|

### Editors

In general, you can point your editor to the `.venv` in your project directory. 
Otherwise, `./dust exec <editor-command>` should always work out-of-the box.

## Why `pdm` and not `put your favorite tool here`?

1. While `pip` is improving and is now able to do backtracking, it doesn't
   ensure a lock file (requirements.txt) always up-to-date, nor the ability to
   convert your code to a standalone pypi module uploadable to pypi.org 
   effortless, nor the ability to automatically compute version constraints for the
   dependencies.
2. Conda is slow, not standard, and convicts your users to use conda as well (lock-in)
3. poetry and Pipenv are slow and are not fully standard
4. pip-tools reinvent the standard

## Develop

To test this project for development purpose, use the branch `develop` and test
using the command `./dustenv/test-dust.sh ./install.sh`

# Credits

Federico Simonetta

https://federicosimonetta.eu.org
