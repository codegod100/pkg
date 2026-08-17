import formula

pub fn formula() -> formula.Formula {
  formula.Formula(
    "conda-hello",
    "2.12.1",
    "GNU Hello from a conda-forge binary package",
    "https://www.gnu.org/software/hello/",
    formula.FromSource("conda-forge://hello", "pixi-lock"),
    ["hello"],
    [formula.Buck2Workspace("src/formulas/conda_hello", "//:hello")],
  )
}
