import formula
import formulas/bat
import formulas/fd
import formulas/hello
import formulas/jq
import formulas/ripgrep
import gleam/list
import gleam/string

pub type Formula =
  formula.Formula

pub fn catalogue() -> List(Formula) {
  [
    ripgrep.formula(),
    fd.formula(),
    jq.formula(),
    hello.formula(),
    bat.formula(),
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
