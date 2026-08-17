pub type Error {
  Unavailable
  Failed(String)
}

@external(erlang, "pkg_ffi", "buck2_build")
fn buck2_build_ffi(target: String) -> Result(String, String)

pub fn build(target: String) -> Result(String, Error) {
  case buck2_build_ffi(target) {
    Ok(output) -> Ok(output)
    Error(message) -> Error(Failed(message))
  }
}
