# ZK Pigeonhole

## Demos

* Generate and check a propositional pigeonhole refutation with ZKUNSAT (e.g., `make test_zkunsat`)
* Generate and check a propositional pigeonhole refutation with lean (e.g., `make test_lean`)

## Recommended entry-points:

* Generate propositional pigeonhole CNFs (UNSAT): `./gen_pigeonhole_cnf.py N_PIGEONS`
  * Prints the CNF to stdout
* Generate a refutation with picosat and check it with ZKUNSAT: `./zkunsat/run.zsh CNF_PATH`
* Generate a refutation with picosat and check it with lean: `./lean/run.zsh CNF_PATH`

## Set-Up and Dependencies

Build `picosat` with `make picosat-965/picosat`

* C toolchain (to build picosat)
* `zsh`, `python3` (scripting)
* `lean` (proof-checking)
* [ZKUNSAT](https://github.com/PP-FM/ZKUNSAT) (proof-checking)
  * it is assumed to be a sibling directory to this repo's root directory, and it is assumed to be already built.
