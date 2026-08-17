# pkg

A small, safe, user-local alternative to `brew`, written in Gleam. It provides a
single binary for searching a curated formula catalogue and tracking installed
packages. No root privileges or shell evaluation are needed.

## Usage

```text
gleam run -- search <term>
gleam run -- info <formula>
gleam run -- install <formula>
gleam run -- uninstall <formula>
gleam run -- list
```

The catalogue is deliberately compiled into the first release so the command
works offline. `update` reports that the local catalogue is current. Downloads
and archive extraction are the next planned layer; install currently records a
formula only after validating that it exists.

## Buck2 remote execution

Formulae using `formula.Buck2` use Buck2's native remote execution flags. Set
`PKG_BUCK2_REMOTE=prefer` to prefer remote execution, or `only` to require it:

```bash
PKG_BUCK2_REMOTE=prefer pixi run ./pkg install bat
PKG_BUCK2_REMOTE=only pixi run ./pkg install bat
```

Remote execution/cache endpoints and credentials remain Buck2 configuration;
`pkg` does not depend on BuildBuddy.
