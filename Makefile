test_lean:
	./gen_pigeonhole_cnf.py 2 > p.cnf && ./lean/run.zsh p.cnf
test_zkunsat:
	./gen_pigeonhole_cnf.py 2 > p.cnf && ZKUNSAT_DIR=../ZKUNSAT ./zkunsat/run.zsh p.cnf
