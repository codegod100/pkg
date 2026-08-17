pub type Source {
  Prebuilt(url: String, sha256: String)
  FromSource(url: String, sha256: String)
}

pub type BuildStep {
  Run(command: String, arguments: List(String))
  Install(source: String, destination: String)
  Buck2(target: String)
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
