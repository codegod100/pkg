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
