-module(pkg_ffi).
-export([install/5, buck2_build/1]).
install(Url0, Checksum0, Name0, Version0, Binary0) ->
  Url = unicode:characters_to_list(Url0), Checksum = unicode:characters_to_list(Checksum0), Name = unicode:characters_to_list(Name0), Version = unicode:characters_to_list(Version0), Binary = unicode:characters_to_list(Binary0),
  Home = case os:getenv("HOME") of false -> "."; Value -> Value end,
  Root = filename:join([Home, ".local", "share", "pkg"]),
  Cellar = filename:join([Root, "Cellar", Name, Version]),
  Bin = filename:join([Home, ".local", "bin"]),
  Tmp = filename:join([Root, "tmp-" ++ Name ++ "-" ++ Version ++ ".tar.gz"]),
  ok = filelib:ensure_dir(filename:join(Cellar, "x")),
  ok = filelib:ensure_dir(filename:join(Bin, "x")),
  Target = filename:join([Cellar, "bin", Binary]),
  Cmd = "curl --fail --location --silent --show-error --proto '=https' --tlsv1.2 -o " ++ q(Tmp) ++ " " ++ q(Url) ++
        " && test \"$(sha256sum " ++ q(Tmp) ++ " | awk '{print $1}')\" = " ++ q(Checksum) ++
        " && tar -xzf " ++ q(Tmp) ++ " -C " ++ q(Cellar) ++ " --strip-components=1 && mkdir -p " ++ q(filename:dirname(Target)) ++
        " && Found=$(find " ++ q(Cellar) ++ " -type f -name " ++ q(Binary) ++ " -print -quit) && test -n \"$Found\" && cp \"$Found\" " ++ q(Target) ++
        " && chmod +x " ++ q(Target) ++ " && ln -sfn " ++ q(Target) ++ " " ++ q(filename:join(Bin, Binary)) ++ " && rm -f " ++ q(Tmp),
  case os:cmd(Cmd) of
    [] -> {ok, unicode:characters_to_binary(filename:join(Bin, Binary))};
    Output -> {error, Output}
  end.
q(S) -> "'" ++ string:replace(S, "'", "'\"'\"'", all) ++ "'".


buck2_build(Target0) ->
  Target = unicode:characters_to_list(Target0),
  case os:find_executable("buck2") of
    false -> {error, "buck2 was not found on PATH"};
    _ ->
      Mode = case os:getenv("PKG_BUCK2_REMOTE") of
        "only" -> " --remote-only";
        "prefer" -> " --prefer-remote";
        "local" -> "";
        _ -> " --prefer-remote"
      end,
      Command = "buck2 build " ++ q(Target) ++ Mode ++ " --show-output 2>&1",
      Output = os:cmd(Command),
      case string:find(Output, "BUILD SUCCEEDED") of
        nomatch -> {error, unicode:characters_to_binary(Output)};
        _ -> {ok, unicode:characters_to_binary(Output)}
      end
  end.
