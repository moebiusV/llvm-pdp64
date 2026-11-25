#!/bin/sh
# Put the pdp64 target into an LLVM source tree (default ../llvm-project next to this repository, tag llvmorg-21.1.8): apply llvm-core.patch (the
# small changes to LLVM's own files: the triple, EM_PDP64 and its relocations, the experimental target list) and copy the target
# directory to llvm/lib/Target/PDP64.  Idempotent.  The tree is a scratch clone; nothing here is committed to it.
set -e
here=$(CDPATH= cd -- "$(dirname "$0")" && pwd -P)
SIB=$(dirname "$here")
P=${PDP64:-$SIB/pdp64}        # the pdp64 checkout: the grammar and the generator of the tables
L=${1:-${LLVM_SRC:-$SIB/llvm-project}}
[ -f "$L/llvm/lib/Target/CMakeLists.txt" ] || { echo "$L is not an LLVM source tree" >&2; exit 1; }
[ -x "$P/tools/gen-llvm-td.py" ] || { echo "no pdp64 checkout at $P (set PDP64)" >&2; exit 1; }
LLVM_PDP64="$here" "$P/tools/gen-llvm-td.py" --check || { echo "target/PDP64/gen is stale: run tools/gen-llvm-td.py in the pdp64 checkout" >&2; exit 1; }
cd "$L"
if git apply --reverse --check "$here/patch/llvm-core.patch" 2> /dev/null; then
	echo "llvm-core.patch already applied"
else
	git apply "$here/patch/llvm-core.patch"
	echo "applied llvm-core.patch"
fi
# replace the directory wholesale so that removed files do not linger
rm -rf llvm/lib/Target/PDP64
cp -r "$here/target/PDP64" llvm/lib/Target/PDP64
echo "installed into $L"
