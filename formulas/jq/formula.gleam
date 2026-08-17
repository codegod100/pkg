import formula

pub fn formula() -> formula.Formula {
  formula.Formula(
    "jq",
    "1.7.1",
    "Command-line JSON processor",
    "https://jqlang.github.io/jq/",
    formula.Prebuilt("https://jqlang.github.io/jq/", ""),
    ["jq"],
    [],
  )
}
