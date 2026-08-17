import formula

pub fn formula() -> formula.Formula {
  formula.Formula(
    "ripgrep",
    "14.1.0",
    "Fast recursive search tool",
    "https://github.com/BurntSushi/ripgrep",
    formula.Prebuilt("https://github.com/BurntSushi/ripgrep/releases", ""),
    ["rg"],
    [],
  )
}
