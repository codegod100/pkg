import formula

pub fn formula() -> formula.Formula {
  formula.Formula(
    "hello",
    "0.1.0",
    "A tiny Zig source-built example package",
    "https://github.com/codegod100/pkg",
    formula.FromSource("local://hello", "source"),
    ["pkg-hello"],
    [formula.Buck2("//:hello")],
  )
}
