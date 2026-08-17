import formula

pub fn formula() -> formula.Formula {
  formula.Formula(
    "bat",
    "0.25.0",
    "A cat clone with wings",
    "https://github.com/sharkdp/bat",
    formula.FromSource(
      "https://github.com/sharkdp/bat/releases/download/v0.25.0/bat-v0.25.0-x86_64-unknown-linux-musl.tar.gz",
      "93f47d76abe328c402ef712e9ac92aa6d5bc84d5adcbcaf0bbc5665e5275a941",
    ),
    ["bat"],
    [formula.Buck2("//:bat")],
  )
}
