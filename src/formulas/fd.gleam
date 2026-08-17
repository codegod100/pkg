import formula

pub fn formula() -> formula.Formula {
  formula.Formula(
    "fd",
    "10.2.0",
    "Simple, fast alternative to find",
    "https://github.com/sharkdp/fd",
    formula.Prebuilt("https://github.com/sharkdp/fd/releases", ""),
    ["fd"],
    [],
  )
}
