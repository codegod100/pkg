genrule(
    name = "hello",
    srcs = ["examples/hello.sh"],
    out = "pkg-hello",
    cmd = "cp $SRCDIR/examples/hello.sh $OUT && chmod +x $OUT",
)
