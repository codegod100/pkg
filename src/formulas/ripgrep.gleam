import formula

pub fn formula() -> formula.Formula {
  formula.Formula(
    "ripgrep",
    "14.1.0",
    "Fast recursive search tool",
    "https://github.com/BurntSushi/ripgrep",
    formula.Prebuilt(
      "https://github.com/BurntSushi/ripgrep/releases/download/14.1.0/ripgrep-14.1.0-x86_64-unknown-linux-musl.tar.gz",
      "f84757b07f425fe5cf11d87df6644691c644a5cd2348a2c670894272999d3ba7",
    ),
    ["rg"],
    [],
  )
}
