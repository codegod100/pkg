import formula
import formulas/bat/formula as bat_formula
import formulas/conda_hello/formula as conda_hello_formula
import formulas/fd/formula as fd_formula
import formulas/hello/formula as hello_formula
import formulas/jq/formula as jq_formula
import formulas/ripgrep/formula as ripgrep_formula
import gleam/list
import gleam/string

pub type Formula =
  formula.Formula

pub fn catalogue() -> List(Formula) {
  [
    ripgrep_formula.formula(),
    fd_formula.formula(),
    jq_formula.formula(),
    hello_formula.formula(),
    bat_formula.formula(),
    conda_hello_formula.formula(),
  ]
}

pub fn find(name: String) -> Result(Formula, Nil) {
  list.find(catalogue(), fn(formula) { formula.name == name })
}

pub fn matches(term: String) -> List(Formula) {
  let needle = string.lowercase(term)
  list.filter(catalogue(), fn(formula) {
    string.contains(string.lowercase(formula.name), needle)
    || string.contains(string.lowercase(formula.description), needle)
  })
}
