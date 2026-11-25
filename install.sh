#!/bin/sh
# Put the pdp64 target into an LLVM source tree (default ../llvm-project next to this repository, a tag we have a patch for: 21.1.8 or 22.1.6): apply patch/llvm-core-<version>.patch (the
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
# the core patch is made for one LLVM release: the tree says which
V=$(git describe --tags --exact-match 2> /dev/null | sed "s/^llvmorg-//") || true
PATCH="$here/patch/llvm-core-$V.patch"
[ -n "$V" ] && [ -f "$PATCH" ] || { echo "$L is at '${V:-no release tag}': no patch/llvm-core-<version>.patch for it (have: $(ls "$here/patch" | sed 's/llvm-core-//; s/\.patch//' | tr '\n' ' '))" >&2; exit 1; }
if git apply --reverse --check "$PATCH" 2> /dev/null; then
	echo "llvm-core-$V.patch already applied"
else
	git apply "$PATCH"
	echo "applied llvm-core-$V.patch"
fi
# replace the directory wholesale so that removed files do not linger
rm -rf llvm/lib/Target/PDP64
cp -r "$here/target/PDP64" llvm/lib/Target/PDP64
echo "installed into $L"
