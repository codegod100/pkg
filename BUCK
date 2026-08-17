genrule(
    name = "greeting",
    srcs = ["examples/greeting.zig"],
    out = "greeting.zig",
    cmd = "cp $SRCDIR/examples/greeting.zig $OUT",
)

genrule(
    name = "hello",
    srcs = ["examples/hello.zig", ":greeting"],
    out = "pkg-hello",
    cmd = "mkdir -p $TMPDIR/src && cp $SRCDIR/examples/hello.zig $TMPDIR/src/hello.zig && cp $SRCDIR/greeting.zig $TMPDIR/src/greeting.zig && zig build-exe $TMPDIR/src/hello.zig -O ReleaseSmall -femit-bin=$OUT",
)
