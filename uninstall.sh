#!/bin/env sh

thisdir=$(dirname $0)

# removing pyenv
LOCALREPO=${thisdir}/pyenv
rm -rf ${LOCALREPO}/*
rm -rf ${LOCALREPO}/.*
rm .python-version
rm .dust-mode

# removing __pypackages__
rm -rf __pypackages__
rm pdm.lock
rm .pdm.toml
