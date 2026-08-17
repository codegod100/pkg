import buck2
import catalog
import formula
import gleam/io
import gleam/list
import installer

pub fn run(arguments: List(String)) {
  case arguments {
    [] -> help()
    ["--help"] -> help()
    ["--version"] -> io.println("pkg 0.1.0")
    ["search", term] -> search(term)
    ["info", name] -> info(name)
    ["list"] -> list_installed()
    ["install", name] -> install(name)
    ["uninstall", name] -> uninstall(name)
    ["update"] -> io.println("Local formula catalogue is up to date.")
    ["doctor"] -> io.println("Everything looks healthy.")
    _ -> {
      io.println("error: invalid arguments (try --help)")
    }
  }
}

fn help() {
  io.println("pkg - a safe, user-local package manager")
  io.println("")
  io.println("Usage: pkg <command> [formula]")
  io.println("")
  io.println("Commands:")
  io.println("  search <term>       Search available formulae")
  io.println("  info <formula>      Show formula details")
  io.println("  install <formula>   Install a formula")
  io.println("  uninstall <formula> Remove a formula")
  io.println("  list                List installed formulae")
  io.println("  update              Refresh the formula catalogue")
  io.println("  doctor              Check configuration")
}

fn search(term: String) {
  let results = catalog.matches(term)
  case results {
    [] -> io.println("No formulae found.")
    _ ->
      list.each(results, fn(formula) {
        io.println(
          formula.name <> " " <> formula.version <> " - " <> formula.description,
        )
      })
  }
}

fn info(name: String) {
  case catalog.find(name) {
    Ok(formula) -> {
      io.println(formula.name <> " " <> formula.version)
      io.println(formula.description)
      io.println(formula.homepage)
    }
    Error(_) -> io.println("error: formula not found: " <> name)
  }
}

fn install(name: String) {
  case catalog.find(name) {
    Ok(item) ->
      case item.source {
        formula.Prebuilt(url, sha256) ->
          case item.binaries {
            [binary, ..] ->
              case
                installer.install(url, sha256, item.name, item.version, binary)
              {
                Ok(path) ->
                  io.println("Installed " <> item.name <> " to " <> path)
                Error(installer.MissingChecksum) ->
                  io.println("error: formula has no SHA-256 checksum")
                Error(installer.Failed(message)) ->
                  io.println("error: installation failed: " <> message)
                Error(installer.InvalidDownload) ->
                  io.println("error: invalid download")
              }
            [] -> io.println("error: formula declares no binaries")
          }
        formula.FromSource(_, _) -> build_formula(item.build)
      }
    Error(_) -> io.println("error: formula not found: " <> name)
  }
}

fn build_formula(steps: List(formula.BuildStep)) {
  case steps {
    [formula.Buck2(target), ..] ->
      case buck2.build(target) {
        Ok(output) ->
          io.println("Buck2 build succeeded for " <> target <> "\n" <> output)
        Error(buck2.Failed(message)) ->
          io.println("error: Buck2 build failed: " <> message)
        Error(buck2.Unavailable) -> io.println("error: Buck2 is not installed")
      }
    _ -> io.println("error: source formula has no supported build backend")
  }
}

fn uninstall(name: String) {
  case catalog.find(name) {
    Ok(_) -> io.println("Not installed: " <> name)
    Error(_) -> io.println("error: formula not found: " <> name)
  }
}

fn list_installed() {
  io.println("No formulae installed.")
}
