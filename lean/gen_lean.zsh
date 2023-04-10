#!/usr/bin/env zsh

set -xe

cnf=$1
lean=$2

mydir=${0:a:h}
zkunsat_bin="$mydir/build/test"
zkunsat_sort="$mydir/Sort.py"
zkunsat_unfold="$mydir/unfold_proof.py"
to_lean="$mydir/unfold_to_lean.py"
picosat="$mydir/../picosat-965/picosat"

fname=${cnf:t}
pf=$fname.tracecheck
sorted=$fname.tracecheck.sort
unfold=$fname.tracecheck.sort.unfold

rm -f $pf $sorted $unfold $lean

$picosat $cnf -T $pf || echo 'ok'
python3 $zkunsat_sort $pf > $sorted
python3 $zkunsat_unfold $sorted

$to_lean $unfold > $lean
rm $pf $sorted $unfold


