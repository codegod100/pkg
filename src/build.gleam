import formula

pub type Backend {
  Buck2
}

pub fn buck2(target: String) -> formula.BuildStep {
  formula.Buck2(target)
}

pub fn command(step: formula.BuildStep) -> String {
  case step {
    formula.Buck2(target) -> "buck2 build " <> target
    formula.Buck2Workspace(workspace, target) ->
      "cd " <> workspace <> " && buck2 build " <> target
    formula.Run(command, _) -> command
    formula.Install(source, destination) ->
      "install " <> source <> " " <> destination
  }
}
