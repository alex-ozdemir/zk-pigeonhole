#!/usr/bin/env zsh

set -xe

cnf=$1

mydir=${0:a:h}
fname=${cnf:t}
lean=$fname.lean

$mydir/gen_lean.zsh $cnf $lean
cat $lean
lean $lean
# elan run 3.4.0 lean $lean
rm $lean

