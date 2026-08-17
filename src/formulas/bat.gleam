import formula

pub fn formula() -> formula.Formula {
  formula.Formula(
    "bat",
    "0.25.0",
    "A cat clone with wings",
    "https://github.com/sharkdp/bat",
    formula.Prebuilt("https://github.com/sharkdp/bat/releases", ""),
    ["bat"],
    [],
  )
}
