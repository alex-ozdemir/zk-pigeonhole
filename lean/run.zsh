#!/usr/bin/env zsh

set -xe

mydir=${0:a:h}
zkunsat_bin="$mydir/build/test"
zkunsat_sort="$mydir/Sort.py"
zkunsat_unfold="$mydir/unfold_proof.py"
to_lean="$mydir/unfold_to_lean.py"
picosat="$HOME/repos/picosat/picosat-965/picosat"

cnf=$1

fname=${cnf:t}
pf=$fname.tracecheck
sorted=$fname.tracecheck.sort
unfold=$fname.tracecheck.sort.unfold
lean=$fname.lean

rm -f $pf $sorted $unfold $lean

$picosat $cnf -T $pf || echo 'ok'
wc -l $pf
python $zkunsat_sort $pf > $sorted
python $zkunsat_unfold $sorted

$to_lean $unfold > $lean
cat $lean
lean $lean
# elan run 3.4.0 lean $lean
rm $pf $sorted $unfold $lean

