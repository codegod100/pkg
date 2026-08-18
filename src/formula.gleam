pub type Source {
  Prebuilt(url: String, sha256: String)
  FromSource(url: String, sha256: String)
  // Try downloading a prebuilt binary from `tangled_url`; fall back to building
  // with buck2 in the current working directory when the download fails (e.g. no
  // binary published yet for the running platform).
  TangledOrBuck2(tangled_url: String, buck2_target: String)
}

pub type BuildStep {
  Run(command: String, arguments: List(String))
  Install(source: String, destination: String)
  Buck2(target: String)
  Buck2Workspace(workspace: String, target: String)
}

pub type Formula {
  Formula(
    name: String,
    version: String,
    description: String,
    homepage: String,
    source: Source,
    binaries: List(String),
    build: List(BuildStep),
  )
}
