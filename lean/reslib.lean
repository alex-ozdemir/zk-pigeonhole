-- The main theorem are from https://github.com/ufmg-smite/lean-smt/blob/main/Smt/Reconstruction/Certifying/Resolution.lean
-- (and written by Tomaz Gomes Mascarenhas)
-- Note: they have been adapted to lean3

-- Author: Tomaz Gomes Mascarenhas
theorem resolution_thm : ∀ {A B C : Prop}, (A ∨ B) → (¬ A ∨ C) → B ∨ C :=
begin
  intros A B C h₁ h₂,
  cases h₁ with ap bp,
  {
    cases h₂ with nap cp,
    exact (false.elim (nap ap)),
    exact (or.inr cp),
  },
  {
    exact (or.inl bp)
  }
end

-- Author: Tomaz Gomes Mascarenhas
theorem resolution_thm₂ : ∀ {A C: Prop}, A → (¬ A ∨ C) → C := 
begin
  intros A B a ornac,
  cases ornac with na c,
  exact (false.elim (na a)),
  exact c,
end


-- Author: Tomaz Gomes Mascarenhas
theorem resolution_thm₃ : ∀ {A B: Prop}, (A ∨ B) → ¬ A → B :=
begin
  intros A B hor hna,
  cases hor with ha hb,
  exact false.elim (hna ha),
  exact hb,
end

-- Author: Tomaz Gomes Mascarenhas
theorem resolution_thm₄ : ∀ {A : Prop}, A → ¬ A → false := λ A a na, na a

meta def or_from_assumption : tactic unit := `[ repeat { {left, assumption} <|> right <|> assumption } ]
meta def or_from_or: tactic unit := do
  `[ intros H, repeat { { or_from_assumption } <|> cases H, } ]
