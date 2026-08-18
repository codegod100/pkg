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

@external(erlang, "pkg_ffi", "try_install")
fn try_install_ffi(
  url: String,
  name: String,
  version: String,
  binary: String,
) -> Result(String, String)

/// Download a raw binary from `url` without checksum verification.
/// Used for Tangled artifacts (content-addressed blobs) where the CID is not
/// known in advance. Returns Error on any download failure (e.g. 404 — binary
/// not yet published) so the caller can fall back to a source build.
pub fn try_install(
  url: String,
  name: String,
  version: String,
  binary: String,
) -> Result(String, InstallError) {
  case try_install_ffi(url, name, version, binary) {
    Ok(path) -> Ok(path)
    Error(message) -> Error(Failed(message))
  }
}
