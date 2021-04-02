#!/bin/sh

if [ "$(uname -s)" = "Darwin" ]
then
  . $(brew --prefix asdf)/asdf.sh
fi
