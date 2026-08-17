-module(pkg_ffi).
-export([install/5, buck2_build/1, buck2_install/4]).
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
        " && rm -f " ++ q(Target) ++ " && tar -xzf " ++ q(Tmp) ++ " -C " ++ q(Cellar) ++ " --strip-components=1 && mkdir -p " ++ q(filename:dirname(Target)) ++
        " && Found=$(find " ++ q(Cellar) ++ " -type f -name " ++ q(Binary) ++ " -print -quit) && test -n \"$Found\" && cp \"$Found\" " ++ q(Target) ++
        " && chmod +x " ++ q(Target) ++ " && ln -sfn " ++ q(Target) ++ " " ++ q(filename:join(Bin, Binary)) ++ " && rm -f " ++ q(Tmp),
  case os:cmd(Cmd) of
    [] -> {ok, unicode:characters_to_binary(filename:join(Bin, Binary))};
    Output -> {error, unicode:characters_to_binary(Output)}
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
        "prefer" -> " --prefer-remote";
        _ -> " --remote-only"
      end,
      Home = case os:getenv("HOME") of false -> "."; H -> H end,
      Config = case os:getenv("PKG_BUCK2_CONFIG") of
        {error, _} -> "";
        false -> find_config([filename:join([Home, ".config", "pkg", "buck2.config"]), filename:join([Home, ".config", "buck2", "buck2.config"]), filename:join(Home, ".buckconfig")]);
        Path -> Path
      end,
      ConfigArg = case Config of "" -> ""; _ -> " --config-file " ++ q(Config) end,
      Command = "buck2 kill >/dev/null 2>&1 || true; mkdir -p buck-out/v2; buck2 build " ++ q(Target) ++ Mode ++ ConfigArg ++ " --show-output 2>&1",
      Output = os:cmd(Command),
      case string:find(Output, "BUILD SUCCEEDED") of
        nomatch -> {error, unicode:characters_to_binary(Output)};
        _ -> {ok, unicode:characters_to_binary(Output)}
      end
  end.


buck2_install(Target0, Name0, Version0, Binary0) ->
  Target = unicode:characters_to_list(Target0), Name = unicode:characters_to_list(Name0),
  Version = unicode:characters_to_list(Version0), Binary = unicode:characters_to_list(Binary0),
  Home = case os:getenv("HOME") of false -> "."; Value -> Value end,
  Root = filename:join([Home, ".local", "share", "pkg"]),
  Cellar = filename:join([Root, "Cellar", Name, Version]),
  Bin = filename:join([Home, ".local", "bin"]),
  Cmd = "buck2 kill >/dev/null 2>&1 || true; mkdir -p buck-out/v2; buck2 build " ++ q(Target) ++ " --show-output 2>&1",
  Output = os:cmd(Cmd),
  case string:find(Output, "BUILD SUCCEEDED") of
    nomatch -> {error, unicode:characters_to_binary(Output)};
    _ ->
      Lines = string:lexemes(Output, "\n"),
      Paths = [P || L <- Lines, P <- output_path(L), filelib:is_file(P)],
      case Paths of
        [Source|_] ->
          Destination = filename:join([Cellar, "bin", Binary]),
          ok = filelib:ensure_dir(filename:join(filename:dirname(Destination), "x")),
          ok = file:del_dir_r(filename:join([Cellar, "bin"])),
          ok = filelib:ensure_dir(filename:join(filename:dirname(Destination), "x")),
          case file:copy(Source, Destination) of
            {ok, _} -> ok = file:change_mode(Destination, 8#755), ok = filelib:ensure_dir(filename:join(Bin, "x")),
              _ = file:make_symlink(Destination, filename:join(Bin, Binary)),
              {ok, unicode:characters_to_binary(filename:join(Bin, Binary))};
            {error, Reason} -> {error, unicode:characters_to_binary(io_lib:format("~p", [Reason]))}
          end;
        [] -> {error, <<"Buck2 succeeded but no output artifact was found">>}
      end
  end.
output_path(Line) ->
  case string:split(Line, " ", all) of
    [_, Path] -> [Path];
    _ -> []
  end.


find_config([]) -> "";
find_config([Path|Rest]) -> case filelib:is_file(Path) of true -> Path; false -> find_config(Rest) end.
