-module(pkg_ffi).
-export([install/4]).
install(Url0, Name0, Version0, Binary0) ->
  Url = unicode:characters_to_list(Url0), Name = unicode:characters_to_list(Name0), Version = unicode:characters_to_list(Version0), Binary = unicode:characters_to_list(Binary0),
  Home = case os:getenv("HOME") of false -> "."; Value -> Value end,
  Root = filename:join([Home, ".local", "share", "pkg"]),
  Cellar = filename:join([Root, "Cellar", Name, Version]),
  Bin = filename:join([Home, ".local", "bin"]),
  Tmp = filename:join([Root, "tmp-" ++ Name ++ "-" ++ Version ++ ".tar.gz"]),
  ok = filelib:ensure_dir(filename:join(Cellar, "x")),
  ok = filelib:ensure_dir(filename:join(Bin, "x")),
  Cmd = "curl --fail --location --silent --show-error --proto '=https' --tlsv1.2 -o " ++ q(Tmp) ++ " " ++ q(Url) ++
        " && tar -xzf " ++ q(Tmp) ++ " -C " ++ q(Cellar) ++ " --strip-components=1 && ln -sfn " ++ q(filename:join(Cellar, Binary)) ++ " " ++ q(filename:join(Bin, Binary)) ++ " && rm -f " ++ q(Tmp),
  case os:cmd(Cmd) of
    [] -> {ok, unicode:characters_to_binary(filename:join(Bin, Binary))};
    Output -> {error, Output}
  end.
q(S) -> "'" ++ string:replace(S, "'", "'\"'\"'", all) ++ "'".
