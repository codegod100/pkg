pub type InstallError {
  MissingChecksum
  InvalidDownload
  Failed(String)
}

@external(erlang, "pkg_ffi", "install")
fn install_ffi(
  url: String,
  sha256: String,
  name: String,
  version: String,
  binary: String,
) -> Result(String, String)

pub fn install(
  url: String,
  sha256: String,
  name: String,
  version: String,
  binary: String,
) -> Result(String, InstallError) {
  case sha256 {
    "" -> Error(MissingChecksum)
    _ ->
      case install_ffi(url, sha256, name, version, binary) {
        Ok(path) -> Ok(path)
        Error(message) -> Error(Failed(message))
      }
  }
}
