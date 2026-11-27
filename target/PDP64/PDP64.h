//===-- PDP64.h - Top-level interface for the pdp64 back end ----*- C++ -*-===//
#ifndef LLVM_LIB_TARGET_PDP64_PDP64_H
#define LLVM_LIB_TARGET_PDP64_PDP64_H

#include "gen/PDP64GenLayout.h"
#include "MCTargetDesc/PDP64MCTargetDesc.h"
#include "llvm/Support/CodeGen.h"

namespace llvm {
class FunctionPass;
class PDP64TargetMachine;
class PassRegistry;

FunctionPass *createPDP64CheckFold();
FunctionPass *createPDP64VecLoop();
void initializePDP64VecLoopPass(PassRegistry &);
void initializePDP64CheckFoldPass(PassRegistry &);
FunctionPass *createPDP64ISelDag(PDP64TargetMachine &TM,
                                 CodeGenOptLevel OptLevel);
void initializePDP64DAGToDAGISelLegacyPass(PassRegistry &);
void initializePDP64AsmPrinterPass(PassRegistry &);
} // namespace llvm

namespace llvm {
// the kind of the table of check sites (1 bounds, 2 null, 3 range, 4 assertion) for the argument of llvm.ubsantrap
// (clang's SanitizerHandler: 18 out-of-bounds, 14-17 and 22 null / nonnull, 20 shift out of bounds, 24 VLA bound; the rest are assertions)
inline unsigned pdp64CheckKindOfUbsan(unsigned H) {
  switch (H) {
  case 18: return 1;
  case 14: case 15: case 16: case 17: case 22: return 2;
  case 20: case 24: return 3;
  default: return 4;
  }
}
} // namespace llvm

// Condition codes.  The integer ones are the cbCC / setCC suffixes of the grammar (generated list).  The floating-point ones name a
// floating-point compare-and-branch (fcbCC a, b, L: eq ne lt le uo or) or a pair of them; the machine has no flags and no "not less than":
//   FCC_EQ FCC_NE FCC_LT FCC_LE FCC_UO FCC_OR   one instruction, fcb<cc> (fcb<cc>.f32 for binary32)
//   FCC_ULT  a<b or unordered       fcbuo a,b,L ; fcblt a,b,L
//   FCC_ULE  a<=b or unordered      fcbuo a,b,L ; fcble a,b,L
//   FCC_UEQ  a==b or unordered      fcbuo a,b,L ; fcbeq a,b,L
//   FCC_ONE  a<b or a>b (ordered)   fcblt a,b,L ; fcblt b,a,L
// (a > b is a < b with the operands swapped by the lowering).  The set is closed under negation, see fpInvert.
namespace PDP64CC {
enum CondCode : unsigned {
#define X(c) COND_##c,
  PDP64_CB_CONDS(X)
#undef X
  FCC_EQ, FCC_NE, FCC_LT, FCC_LE, FCC_UO, FCC_OR,
  FCC_ULT, FCC_ULE, FCC_UEQ, FCC_ONE,
  COND_INVALID
};

inline const char *getCondName(unsigned CC) {
  static const char *const Names[] = {
#define X(c) #c,
      PDP64_CB_CONDS(X)
#undef X
      "eq", "ne", "lt", "le", "uo", "or",
      "ult", "ule", "ueq", "one",
  };
  return CC < sizeof(Names) / sizeof(Names[0]) ? Names[CC] : "??";
}

inline bool isFPCond(unsigned CC) { return CC >= FCC_EQ && CC <= FCC_ONE; }

// The immediate of cbCC: 16 bits signed (CbImmBits) for eq, ne and the unsigned conditions with any register; the signed lt, le, gt, ge
// have the 16-bit immediate only with a hot register (4-bit register field) and 12 bits otherwise (found by trying as64: cblt r17, #2048 is
// an error).  The register allocator does not know which registers are hot, so the compiler uses the 12 bits for those four.
inline bool cbImmFits(unsigned CC, int64_t V) {
  if (CC == COND_lt || CC == COND_le || CC == COND_gt || CC == COND_ge)
    return V >= -2048 && V <= 2047;
  return V >= -(int64_t(1) << (PDP64Layout::CbImmBits - 1)) && V < (int64_t(1) << (PDP64Layout::CbImmBits - 1));
}

// the inverse of an integer condition
inline CondCode invert(CondCode CC) {
  switch (CC) {
  case COND_eq: return COND_ne;
  case COND_ne: return COND_eq;
  case COND_lt: return COND_ge;
  case COND_ge: return COND_lt;
  case COND_gt: return COND_le;
  case COND_le: return COND_gt;
  case COND_cs: return COND_cc;
  case COND_cc: return COND_cs;
  case COND_hi: return COND_los;
  case COND_los: return COND_hi;
  default: return COND_INVALID;
  }
}

// The exact negation of a floating-point condition (NaN included): the new condition, and whether the operands are swapped.
//   !(a == b) = a != b      !(a < b)  = b <= a or unordered      !(a <= b) = b < a or unordered
//   !(a < b or uo) = b <= a     !(a <= b or uo) = b < a     !(a == b or uo) = a < b or a > b
inline CondCode fpInvert(CondCode CC, bool &Swap) {
  Swap = false;
  switch (CC) {
  case FCC_EQ: return FCC_NE;
  case FCC_NE: return FCC_EQ;
  case FCC_UO: return FCC_OR;
  case FCC_OR: return FCC_UO;
  case FCC_UEQ: return FCC_ONE;
  case FCC_ONE: return FCC_UEQ;
  case FCC_LT: Swap = true; return FCC_ULE;
  case FCC_LE: Swap = true; return FCC_ULT;
  case FCC_ULT: Swap = true; return FCC_LE;
  case FCC_ULE: Swap = true; return FCC_LT;
  default: return COND_INVALID;
  }
}
} // namespace PDP64CC

#endif
