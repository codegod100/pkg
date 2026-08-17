genrule(
    name = "hello",
    srcs = ["examples/hello.zig"],
    out = "pkg-hello",
    cmd = "zig build-exe $SRCDIR/examples/hello.zig -O ReleaseSmall -femit-bin=$OUT",
)
