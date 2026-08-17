export BUCK_SCRATCH_PATH=../../../../../../../$BUCK_SCRATCH_PATH
cd buck-out/v2/art/root/a8ac7ec86a6bee54/__greeting__/srcs
mkdir -p ../out || exit 99
export TMP=${TMPDIR:-/tmp}
cp $SRCDIR/src/greeting.zig $OUT