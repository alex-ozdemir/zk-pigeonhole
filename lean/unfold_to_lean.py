#!/usr/bin/env python3

# Based on part of the ZKUNSAT source distribution, written by Ning Luo and Xiao Wang
# https://github.com/PP-FM/ZKUNSAT

from array import array
from typing import List
from dataclasses import dataclass
import sys

# From ZKUNSAT
@dataclass
class ResolutionTuple:
    index:int;
    clause : set;
    support : array;
    pivot: array;

    def print(self):
        print("index: ", self.index, " clause: ", " ".join([str(i) for i in self.clause]), " support: ", " ".join([str(i) for i in self.support]), " pivot: ", " ".join([str(i) for i in self.pivot]), "end: ", str(0))


# From ZKUNSAT
def parse(str):
    #ResTuple = resolution()
    line_tmp = str.split(" ")
    line = []
    for e in line_tmp:
        if e != '':
            line.append(e)
    index = int(line[1])
    clause = set();
    pivots = []
    support = []
    i = 3
    while (line[i].strip(" ") != 'support:'):
        clause.add(int(line[i]))
        i = i + 1
    i = i + 1
    while (line[i].strip(" ") != 'pivot:'):
        support.append(int(line[i]))
        i = i + 1
    i = i + 1
    while (line[i].strip(" ") != 'end:'):
        pivots.append(int(line[i]))
        i = i + 1
    if len(clause) == 0:
        clause.add(0)
    res = ResolutionTuple(index, clause, support, pivots)
    return res

# From ZKUNSAT
def process ( filename, start = 0):
    resolution_list = []
    proof = open(filename, 'r')
    Lines = proof.readlines()

    for line in Lines:
        str = line.split(" ")
        if str[0] == "DEGREE:":
            degree = int(str[1])
            break
        res = parse(line)
        resolution_list.append(res)
    return resolution_list, degree

# Our own implementation begins here.
OR = "∨"
TO = "→"
FORALL = "∀"
NOT = "¬"
proofname = sys.argv[1]
pf, degree = process(proofname)
n_vars = max(max(abs(l) for l in t.clause) for t in pf)
vs = [f"x{i+1}" for i in range(n_vars)]

def lean_clause(c: List[int]) -> str:
    return "(" + f" {OR} ".join(map(lean_lit, (l for l in c if l != 0))) + ")"

def lean_lit(l: int) -> str:
    if l < 0:
        return f"{NOT}{vs[abs(l)-1]}"
    elif l > 0:
        return f"{vs[abs(l)-1]}"
    else:
        print(l)
        raise Exception()

for res in pf:
    res.clause = list(res.clause)
print("import .lean.reslib")
print(f"theorem myres ({' '.join(vs)} : Prop)")

for res in pf:
    if not res.support:
        print(f"  (c{res.index} : {lean_clause(list(res.clause))})")
print("  : false := begin")
for res in pf:
    if res.support:
        p = res.pivot[0]
        ai = res.support[0]
        bi = res.support[1]
        if p < 0:
            p = abs(p)
            ai, bi = bi, ai
        a = pf[ai].clause
        b = pf[bi].clause
        ad = list(set(a) - {p})
        bd = list(set(b) - {-p})
        ao = [p] + ad
        bo = [-p] + bd
        i = res.index
        al = len(ao)
        bl = len(bo)
        ad = lean_clause(ad)
        a = lean_clause(list(a))
        ao = lean_clause(list(ao))
        bd = lean_clause(bd)
        b = lean_clause(list(b))
        bo = lean_clause(list(bo))
        c = lean_clause(list(res.clause))
        print(f"  -- derive clause {i}: {c}")
        print(f"   have c{i}a : {ao} :=")
        print(f"    by {{ have a : {a} {TO} {ao} := by or_from_or, exact a c{ai}}},")
        print(f"   have c{i}b : {bo} :=")
        print(f"    by {{ have a : {b} {TO} {bo} := by or_from_or, exact a c{bi}}},")
        if al > 1 and bl > 1:
            print(f"   have c{i}r := resolution_thm c{i}a c{i}b,")

            print(f"   have c{i} : {c} := by {{ have a : {ad} ∨ {bd} → {c} := by or_from_or, exact a c{i}r }},")
        elif al == 1 and bl > 1:
            print(f"   have c{i} := resolution_thm₂ c{i}a c{i}b,")
        elif al > 1 and bl == 1:
            print(f"   have c{i} := resolution_thm₃ c{i}a c{i}b,")
        elif al == 1 and bl == 1:
            print(f"   exact resolution_thm₄ c{i}a c{i}b,")
        else:
            raise Exception()
#print("  sorry")
print("end")
#print("  #print myres")
