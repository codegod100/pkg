export BUCK_SCRATCH_PATH=../../../../../../../$BUCK_SCRATCH_PATH
cd buck-out/v2/art/root/a8ac7ec86a6bee54/__hello__/srcs
mkdir -p ../out || exit 99
export TMP=${TMPDIR:-/tmp}
mkdir -p $TMPDIR/src && cp $SRCDIR/src/hello.zig $TMPDIR/src/hello.zig && cp $SRCDIR/greeting.zig $TMPDIR/src/greeting.zig && zig build-exe $TMPDIR/src/hello.zig -O ReleaseSmall -femit-bin=$OUT