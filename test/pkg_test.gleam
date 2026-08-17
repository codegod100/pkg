import catalog
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

pub fn finds_known_formula() {
  catalog.find("jq") |> should.be_ok()
}

pub fn unknown_formula_is_missing() {
  catalog.find("not-a-formula") |> should.be_error()
}
