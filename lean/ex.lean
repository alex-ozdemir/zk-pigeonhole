-- A test of our resolution approach/library
import .reslib

example (A B C: Prop) (a : A) : (A ∨ B ∨ C) := by or_from_assumption
example (A B C: Prop) (a : B) : (A ∨ B ∨ C) := by or_from_assumption
example (A B C: Prop) (a : C) : (A ∨ B ∨ C) := by or_from_assumption

example (A B C: Prop) :
  (A ∨ A ∨ B ∨ B ∨ C) → 
  (A ∨ B ∨ C)
  :=
begin
  have i : ((A ∨ A ∨ B ∨ B ∨ C) → (A ∨ B ∨ C)), or_from_or,
end

example (A B C: Prop) :
  (A ∨ (A ∨ B) ∨ (B ∨ C) ∨ B ∨ C) → 
  (A ∨ B ∨ C)
  := by or_from_or


example (A B C: Prop) :
  (B ∨ A ∨ C) → 
  (A ∨ B ∨ C)
  := by or_from_or

theorem res_ex (A B C : Prop)
  (c1 : A ∨ B ∨ C) 
  (c2 : ¬ A ∨ B ∨ C) 
  (c3 : ¬ B)
  (c4 : ¬ C) :
  false :=
begin
  have r1c1 : (A ∨ B ∨ C) := by { have a : A ∨ B ∨ C → (A ∨ B ∨ C) := by or_from_or, exact a c1},
  have r1c2 : (¬ A ∨ B ∨ C) := by { have a : ¬ A ∨ B ∨ C → (¬ A ∨ B ∨ C) := by or_from_or, exact a c2},
  have r1r := resolution_thm r1c1 r1c2,
  have c5 : B ∨ C := by { have a : (B ∨ C) ∨ (B ∨ C) → B ∨ C  := by or_from_or, exact a r1r },
  have r2c1 : (B ∨ C) := by { have a : B ∨ C → (B ∨ C) := by or_from_or, exact a c5},
  have r2c2 : (¬ B) := by { have a : ¬ B → (¬ B) := by or_from_or, exact a c3},
  have c6 := resolution_thm₃ r2c1 r2c2,
  exact resolution_thm₄ c6 c4
end

#print res_ex
