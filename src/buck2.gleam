pub type Error {
  Unavailable
  Failed(String)
}

@external(erlang, "pkg_ffi", "buck2_install")
fn buck2_install_ffi(
  workspace: String,
  target: String,
  name: String,
  version: String,
  binary: String,
) -> Result(String, String)

pub fn install(
  workspace: String,
  target: String,
  name: String,
  version: String,
  binary: String,
) -> Result(String, Error) {
  case buck2_install_ffi(workspace, target, name, version, binary) {
    Ok(path) -> Ok(path)
    Error(message) -> Error(Failed(message))
  }
}
