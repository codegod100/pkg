import formula

pub fn formula() -> formula.Formula {
  formula.Formula(
    "fd",
    "10.2.0",
    "Simple, fast alternative to find",
    "https://github.com/sharkdp/fd",
    formula.Prebuilt(
      "https://github.com/sharkdp/fd/releases/download/v10.2.0/fd-v10.2.0-x86_64-unknown-linux-musl.tar.gz",
      "d9bfa25ec28624545c222992e1b00673b7c9ca5eb15393c40369f10b28f9c932",
    ),
    ["fd"],
    [],
  )
}
