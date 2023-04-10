#!/usr/bin/env python3

import argparse
import math

parser = argparse.ArgumentParser(description="Generate pigeon-hole formulas")
parser.add_argument(
    "pigeons",
    metavar="PIGEONS",
    type=int,
    help="how many pigeons to place (in one extra hole)",
)
parser.add_argument("-f", "--format", choices=["dimacs", "lean"], default="dimacs")

args = parser.parse_args()

n_pigeons = args.pigeons
n_holes = n_pigeons + 1


def choose(n, k):
    return math.factorial(n) / math.factorial(k) / math.factorial(n - k)


# indexed by pigeon, then hole.
n_vs = n_pigeons * n_holes
n_clauses = n_pigeons * (n_holes * (n_holes - 1) // 2) + n_holes

if args.format == "dimacs":
    vs = [[i * n_holes + j + 1 for j in range(n_holes)] for i in range(n_pigeons)]
    print(f"p cnf {n_vs} {n_clauses}")
    for p in range(n_pigeons):
        for h1 in range(n_holes):
            for h2 in range(h1):
                print(f"-{vs[p][h1]} -{vs[p][h2]} 0")

    for h in range(n_holes):
        s = ""
        for p in range(n_pigeons):
            s += f"{vs[p][h]} "
        s += "0"
        print(s)
elif args.format == "lean":
    LEAN_FORALL = "∀"
    LEAN_AND = "∧"
    LEAN_OR = "∨"
    LEAN_NOT = "¬"
    LEAN_FALSE = "bool.ff"
    vs = [[f"p_{i}_in_{j}" for j in range(n_holes)] for i in range(n_pigeons)]
# proof conversion breaks.
#     print("import .lean.smtlean.src.cvc4.tactic")
#     print()
#     print(f"def pigeonhole{n_pigeons} :")
#     print(f"  {LEAN_FORALL} (" + " ".join(" ".join(r) for r in vs) + " : bool),")
#     to_or = []
#     for p in range(n_pigeons):
#         for h1 in range(n_holes):
#             for h2 in range(h1):
#                 to_or.append(f"({vs[p][h1]} {LEAN_AND} {vs[p][h2]})")
#     for h in range(n_holes):
#         to_or.append("(" + f" {LEAN_AND} ".join(f"{LEAN_NOT}{vs[p][h]}" for p in range(n_pigeons)) + ")")
#     print("   ", f" {LEAN_OR} \n    ".join(to_or))
#     print(f"  := by do prove")
    print("import .lean.smtlean.src.cvc4.tactic")
    print()
    print(f"def pigeonhole{n_pigeons} :")
    print(f"  {LEAN_FORALL} (" + " ".join(" ".join(r) for r in vs) + " : bool),")
    clauses = []
    for p in range(n_pigeons):
        for h1 in range(n_holes):
            for h2 in range(h1):
                clauses.append(f"{LEAN_NOT}{vs[p][h1]} {LEAN_OR} {LEAN_NOT}{vs[p][h2]}")
    for h in range(n_holes):
        clauses.append(f" {LEAN_OR} ".join(f"{vs[p][h]}" for p in range(n_pigeons)))
    print(f"   {LEAN_NOT}(", f" {LEAN_AND} \n    ".join(f"({a})" for a in clauses))
    print(f"  ):= by do prove")
else:
    print("Bad format")
