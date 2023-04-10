#!/usr/bin/env zsh

set -xe

mydir=${0:a:h}
if [[ -z $ZKUNSAT_DIR ]]
then
    echo "Must set the envvar ZKUNSAT_DIR to the repo root for ZKUNSAT"
    exit 2
fi
zkunsat_bin="$ZKUNSAT_DIR/build/test"
zkunsat_sort="$ZKUNSAT_DIR/prover_backend/Sort.py"
zkunsat_unfold="$ZKUNSAT_DIR/prover_backend/unfold_proof.py"
picosat="$HOME/repos/picosat/picosat-965/picosat"

cnf=$1
if [[ -z $cnf ]]
then
    echo "The first argument should be a CNF to process"
    exit 2
fi

fname=${cnf:t}
pf=$fname.tracecheck
sorted=$fname.tracecheck.sort
unfold=$fname.tracecheck.sort.unfold

rm -f $pf $sorted $unfold
rm -rf data

$picosat $cnf -T $pf || echo 'ok'
wc -l $pf
python $zkunsat_sort $pf > $sorted
python $zkunsat_unfold $sorted

mkdir data
$zkunsat_bin 1 12345 127.0.0.1 $unfold &
$zkunsat_bin 2 12345 127.0.0.1 $unfold
rm -rf data
rm $pf $sorted $unfold

