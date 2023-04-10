; A direct SMT-LIB2 encoding of the pigeonhole principle.

(set-logic UFNIA)
(declare-fun n () Int)
(declare-fun f (Int) Int)
(assert (> n 1))
(assert
    (forall ((x Int)) (=> (and (<= x n) (>= x 0)) (and (>= (f x) 0) (< (f x) n)))))
(assert
    (forall ((x Int) (y Int)) (=>
        (and (<= x n) (>= x 0)
             (<= y n) (>= y 0)
             (not (= x y)))
        (not (= (f x) (f y))))))
(check-sat)
(get-model)
