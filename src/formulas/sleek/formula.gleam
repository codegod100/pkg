import formula

pub fn formula() -> formula.Formula {
  formula.Formula(
    "sleek",
    "0.1.0",
    "Mobile freeq client (egui desktop host)",
    "https://github.com/codegod100/sleek",
    formula.TangledOrBuck2(
      "https://tangled.org/nandi.uk/sleek/releases/download/dev/sleek",
      "//:sleek-host",
    ),
    ["sleek"],
    [],
  )
}
