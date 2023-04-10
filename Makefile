test_lean: ./picosat-965/picosat
	./gen_pigeonhole_cnf.py 2 > p.cnf && ./lean/run.zsh p.cnf
test_zkunsat: ./picosat-965/picosat
	./gen_pigeonhole_cnf.py 2 > p.cnf && ZKUNSAT_DIR=../ZKUNSAT ./zkunsat/run.zsh p.cnf
./picosat-965/picosat:
	cd picosat-965 && ./configure.sh --static --trace && make -j
clean:
	rm p.cnf && cd picosat-965 && make clean
