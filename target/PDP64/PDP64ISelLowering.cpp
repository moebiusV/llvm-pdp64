#include "PDP64ISelLowering.h"
#include "PDP64.h"
#include "PDP64InstrInfo.h"
#include "PDP64Subtarget.h"
#include "PDP64TargetMachine.h"
#include "llvm/CodeGen/CallingConvLower.h"
#include "llvm/CodeGen/MachineFrameInfo.h"
#include "llvm/CodeGen/MachineFunction.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/MachineJumpTableInfo.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"
#include "llvm/CodeGen/SelectionDAGNodes.h"
#include "llvm/IR/DiagnosticInfo.h"
#include "llvm/IR/Function.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/ErrorHandling.h"

using namespace llvm;

#define DEBUG_TYPE "pdp64-lower"

#include "PDP64GenCallingConv.inc"

PDP64TargetLowering::PDP64TargetLowering(const TargetMachine &TM,
                                         const PDP64Subtarget &STI)
    : TargetLowering(TM, STI), Subtarget(STI) {
  addRegisterClass(MVT::i64, &PDP64::GPRRegClass);
  addRegisterClass(MVT::f64, &PDP64::GPRRegClass);
  addRegisterClass(MVT::f32, &PDP64::GPRRegClass);
  computeRegisterProperties(STI.getRegisterInfo());

  setStackPointerRegisterToSaveRestore(PDP64::R14);
  setBooleanContents(ZeroOrOneBooleanContent);
  setBooleanVectorContents(ZeroOrOneBooleanContent);
  setSchedulingPreference(Sched::Source);
  setMinFunctionAlignment(Align(2)); // instructions are parcels of 16 bits
  setPrefFunctionAlignment(Align(2));
  // atomics (errata 211): the 4- and 8-byte read-modify-write words and the compare and swap are instructions; a byte or a half
  // goes through a 4-byte compare and swap (LLVM's partword expansion), a subtract is an add of the negation, the other operations
  // (nand, the floating-point ones, the wrapping increments) are a compare-and-swap loop (shouldExpandAtomicRMWInIR).  The machine
  // is sequentially consistent: a fence is nothing, and an atomic load or store is an ordinary one.
  setMaxAtomicSizeInBitsSupported(64);
  setMinCmpXchgSizeInBits(32);
  setOperationAction(ISD::ATOMIC_FENCE, MVT::Other, Custom);

  // extending loads: the loads of the machine extend, in both ways
  for (MVT VT : {MVT::i1, MVT::i8, MVT::i16, MVT::i32}) {
    setLoadExtAction(ISD::EXTLOAD, MVT::i64, VT, Legal);
    setLoadExtAction(ISD::ZEXTLOAD, MVT::i64, VT, Legal);
    if (VT != MVT::i1)
      setLoadExtAction(ISD::SEXTLOAD, MVT::i64, VT, Legal);
  }
  setTruncStoreAction(MVT::i64, MVT::i32, Legal);
  setTruncStoreAction(MVT::i64, MVT::i16, Legal);
  setTruncStoreAction(MVT::i64, MVT::i8, Legal);
  setTruncStoreAction(MVT::f64, MVT::f32, Expand);
  setLoadExtAction(ISD::EXTLOAD, MVT::f64, MVT::f32, Expand);

  setOperationAction(ISD::SIGN_EXTEND_INREG, MVT::i1, Expand);
  for (MVT VT : {MVT::i8, MVT::i16, MVT::i32})
    setOperationAction(ISD::SIGN_EXTEND_INREG, VT, Legal);

  // symbols, conditions
  for (unsigned Op : {ISD::GlobalAddress, ISD::ExternalSymbol, ISD::JumpTable,
                      ISD::ConstantPool, ISD::BlockAddress})
    setOperationAction(Op, MVT::i64, Custom);
  setOperationAction(ISD::BR_JT, MVT::Other, Expand);
  setOperationAction(ISD::BRCOND, MVT::Other, Expand);
  for (MVT VT : {MVT::i64, MVT::f32, MVT::f64}) {
    setOperationAction(ISD::BR_CC, VT, Custom);
    setOperationAction(ISD::SELECT_CC, VT, Custom);
    setOperationAction(ISD::SELECT, VT, Expand);
    setOperationAction(ISD::SETCC, VT, Custom);
  }

  // integer arithmetic
  setOperationAction(ISD::SDIVREM, MVT::i64, Expand);
  setOperationAction(ISD::UDIVREM, MVT::i64, Expand);
  setOperationAction(ISD::SMUL_LOHI, MVT::i64, Expand);
  setOperationAction(ISD::UMUL_LOHI, MVT::i64, Expand);
  setOperationAction(ISD::MULHS, MVT::i64, Legal);
  setOperationAction(ISD::MULHU, MVT::i64, Legal);
  setOperationAction(ISD::ROTL, MVT::i64, Custom);
  setOperationAction(ISD::ROTR, MVT::i64, Custom);
  setOperationAction(ISD::CTLZ_ZERO_UNDEF, MVT::i64, Expand);
  setOperationAction(ISD::CTTZ_ZERO_UNDEF, MVT::i64, Expand);
  setOperationAction(ISD::SHL_PARTS, MVT::i64, Expand);
  setOperationAction(ISD::SRL_PARTS, MVT::i64, Expand);
  setOperationAction(ISD::SRA_PARTS, MVT::i64, Expand);
  setOperationAction(ISD::DYNAMIC_STACKALLOC, MVT::i64, Expand);
  setOperationAction(ISD::STACKSAVE, MVT::Other, Expand);
  setOperationAction(ISD::STACKRESTORE, MVT::Other, Expand);
  setOperationAction(ISD::VASTART, MVT::Other, Custom);
  setOperationAction(ISD::VAARG, MVT::Other, Expand);
  setOperationAction(ISD::VACOPY, MVT::Other, Expand);
  setOperationAction(ISD::VAEND, MVT::Other, Expand);
  setOperationAction(ISD::BITCAST, MVT::f32, Custom);
  setOperationAction(ISD::BITCAST, MVT::i32, Custom);

  // floating point: no fma, no minnum/maxnum, no copysign, no rounding to integral
  for (MVT VT : {MVT::f32, MVT::f64}) {
    setOperationAction(ISD::FMA, VT, Expand);
    setOperationAction(ISD::FCOPYSIGN, VT, Expand);
    setOperationAction(ISD::FREM, VT, Expand);
  }
  setOperationAction(ISD::FP_TO_SINT, MVT::i64, Legal);
  setOperationAction(ISD::FP_TO_UINT, MVT::i64, Legal);
  setOperationAction(ISD::SINT_TO_FP, MVT::i64, Legal);
  setOperationAction(ISD::UINT_TO_FP, MVT::i64, Legal);
  setOperationAction(ISD::FP_EXTEND, MVT::f64, Legal);
  setOperationAction(ISD::FP_ROUND, MVT::f32, Legal);
  setOperationAction(ISD::FNEG, MVT::f32, Legal);
  setOperationAction(ISD::FABS, MVT::f32, Legal);
  setOperationAction(ISD::FSQRT, MVT::f32, Legal);
  setOperationAction(ISD::FSQRT, MVT::f64, Legal);

  // (rN)+ and -(rN): the pointer moves by the size of the access
  for (MVT VT : {MVT::i8, MVT::i16, MVT::i32, MVT::i64, MVT::f32, MVT::f64}) {
    setIndexedLoadAction({ISD::POST_INC, ISD::PRE_DEC}, VT, Legal);
    setIndexedStoreAction({ISD::POST_INC, ISD::PRE_DEC}, VT, Legal);
  }
  setOperationAction(ISD::ConstantFP, MVT::f32, Legal);
  setOperationAction(ISD::ConstantFP, MVT::f64, Legal);
  setOperationAction(ISD::TRAP, MVT::Other, Legal);
  setOperationAction(ISD::UBSANTRAP, MVT::Other, Legal);
  setOperationAction(ISD::DEBUGTRAP, MVT::Other, Legal);
}

const char *PDP64TargetLowering::getTargetNodeName(unsigned Opcode) const {
  switch (Opcode) {
  case PDP64ISD::CALL: return "PDP64ISD::CALL";
  case PDP64ISD::RET_GLUE: return "PDP64ISD::RET_GLUE";
  case PDP64ISD::WRAPPER: return "PDP64ISD::WRAPPER";
  case PDP64ISD::BR_CC: return "PDP64ISD::BR_CC";
  case PDP64ISD::SELECT_CC: return "PDP64ISD::SELECT_CC";
  case PDP64ISD::SETCC: return "PDP64ISD::SETCC";
  case PDP64ISD::FSETCC: return "PDP64ISD::FSETCC";
  case PDP64ISD::F32_TO_I64: return "PDP64ISD::F32_TO_I64";
  case PDP64ISD::I64_TO_F32: return "PDP64ISD::I64_TO_F32";
  }
  return nullptr;
}

bool PDP64TargetLowering::isTruncateFree(Type *Ty1, Type *Ty2) const {
  if (!Ty1->isIntegerTy() || !Ty2->isIntegerTy())
    return false;
  return Ty1->getPrimitiveSizeInBits() > Ty2->getPrimitiveSizeInBits();
}
bool PDP64TargetLowering::isTruncateFree(EVT VT1, EVT VT2) const {
  if (!VT1.isInteger() || !VT2.isInteger())
    return false;
  return VT1.getFixedSizeInBits() > VT2.getFixedSizeInBits();
}
bool PDP64TargetLowering::isLegalICmpImmediate(int64_t Imm) const {
  return isInt<PDP64Layout::CbImmBits>(Imm);
}
bool PDP64TargetLowering::isLegalAddImmediate(int64_t Imm) const {
  return isInt<PDP64Layout::AluImmBits>(Imm);
}
bool PDP64TargetLowering::isLegalAddressingMode(const DataLayout &DL,
                                                const AddrMode &AM, Type *Ty,
                                                unsigned AS, Instruction *I) const {
  if (AM.BaseGV) // a symbol, pc-relative: nothing else with it
    return !AM.HasBaseReg && AM.Scale == 0;
  switch (AM.Scale) {
  case 0:
    return isInt<PDP64Layout::DispBits>(AM.BaseOffs);
  case 1:
  case 2:
  case 4:
  case 8:
    return isInt<PDP64Layout::IdxDispBits>(AM.BaseOffs);
  default:
    return false;
  }
}

// (rN)+ : the address is incremented by the size of the access after it
bool PDP64TargetLowering::getPostIndexedAddressParts(
    SDNode *N, SDNode *Op, SDValue &Base, SDValue &Offset,
    ISD::MemIndexedMode &AM, SelectionDAG &DAG) const {
  EVT VT;
  if (auto *LD = dyn_cast<LoadSDNode>(N))
    VT = LD->getMemoryVT();
  else if (auto *ST = dyn_cast<StoreSDNode>(N))
    VT = ST->getMemoryVT();
  else
    return false;
  if (Op->getOpcode() != ISD::ADD)
    return false;
  auto *C = dyn_cast<ConstantSDNode>(Op->getOperand(1));
  if (!C || C->getSExtValue() != (int64_t)VT.getStoreSize())
    return false;
  Base = Op->getOperand(0);
  if (isa<FrameIndexSDNode>(Base))
    return false;
  Offset = Op->getOperand(1);
  AM = ISD::POST_INC;
  return true;
}

// -(rN) : the address is decremented by the size of the access before it
bool PDP64TargetLowering::getPreIndexedAddressParts(SDNode *N, SDValue &Base,
                                                    SDValue &Offset,
                                                    ISD::MemIndexedMode &AM,
                                                    SelectionDAG &DAG) const {
  SDValue Ptr;
  EVT VT;
  if (auto *LD = dyn_cast<LoadSDNode>(N)) {
    VT = LD->getMemoryVT();
    Ptr = LD->getBasePtr();
  } else if (auto *ST = dyn_cast<StoreSDNode>(N)) {
    VT = ST->getMemoryVT();
    Ptr = ST->getBasePtr();
  } else
    return false;
  int64_t Size = VT.getStoreSize();
  if (Ptr.getOpcode() == ISD::ADD) {
    auto *C = dyn_cast<ConstantSDNode>(Ptr.getOperand(1));
    if (!C || C->getSExtValue() != -Size)
      return false;
    AM = ISD::PRE_INC; // with a negative offset
  } else if (Ptr.getOpcode() == ISD::SUB) {
    auto *C = dyn_cast<ConstantSDNode>(Ptr.getOperand(1));
    if (!C || C->getSExtValue() != Size)
      return false;
    AM = ISD::PRE_DEC;
  } else
    return false;
  Base = Ptr.getOperand(0);
  if (isa<FrameIndexSDNode>(Base))
    return false;
  Offset = Ptr.getOperand(1);
  return true;
}

//===----------------------------------------------------------------------===//
// Calling convention
//===----------------------------------------------------------------------===//

// A value narrower than 64 bits that is not marked otherwise travels
// sign-extended (int, short and char of pcc; zeroext marks the unsigned ones).
// The value a register carries for an argument or a result of a type narrower
// than 64 bits is the original value extended: sign-extended (int, short, char
// of pcc) unless the argument is marked zeroext (unsigned char, short; _Bool).
// The generic code has only any-extended it, so this does the rest.
static SDValue extendArg(SelectionDAG &DAG, const SDLoc &DL, const CCValAssign &VA,
                         const ISD::ArgFlagsTy &Flags, EVT OrigVT, SDValue Val) {
  switch (VA.getLocInfo()) {
  case CCValAssign::SExt:
    return DAG.getNode(ISD::SIGN_EXTEND, DL, VA.getLocVT(), Val);
  case CCValAssign::ZExt:
    return DAG.getNode(ISD::ZERO_EXTEND, DL, VA.getLocVT(), Val);
  case CCValAssign::AExt:
    Val = DAG.getNode(ISD::ANY_EXTEND, DL, VA.getLocVT(), Val);
    break;
  default:
    break;
  }
  if (Val.getValueType() == MVT::i64 && OrigVT.isInteger() &&
      OrigVT.getSizeInBits() < 64) {
    if (Flags.isZExt() || OrigVT == MVT::i1)
      return DAG.getZeroExtendInReg(Val, DL, OrigVT);
    return DAG.getNode(ISD::SIGN_EXTEND_INREG, DL, MVT::i64, Val,
                       DAG.getValueType(OrigVT));
  }
  return Val;
}

SDValue PDP64TargetLowering::LowerFormalArguments(
    SDValue Chain, CallingConv::ID CallConv, bool IsVarArg,
    const SmallVectorImpl<ISD::InputArg> &Ins, const SDLoc &DL,
    SelectionDAG &DAG, SmallVectorImpl<SDValue> &InVals) const {
  if (IsVarArg)
    report_fatal_error("pdp64: variadic functions are not implemented (stage 1)");
  MachineFunction &MF = DAG.getMachineFunction();
  MachineFrameInfo &MFI = MF.getFrameInfo();
  MachineRegisterInfo &RegInfo = MF.getRegInfo();

  SmallVector<CCValAssign, 16> ArgLocs;
  CCState CCInfo(CallConv, IsVarArg, MF, ArgLocs, *DAG.getContext());
  CCInfo.AnalyzeFormalArguments(Ins, CC_PDP64);

  for (unsigned i = 0, e = ArgLocs.size(); i != e; ++i) {
    CCValAssign &VA = ArgLocs[i];
    SDValue Val;
    if (VA.isRegLoc()) {
      Register VReg = RegInfo.createVirtualRegister(&PDP64::GPRRegClass);
      RegInfo.addLiveIn(VA.getLocReg(), VReg);
      Val = DAG.getCopyFromReg(Chain, DL, VReg, VA.getLocVT());
    } else {
      assert(VA.isMemLoc());
      ISD::ArgFlagsTy Flags = Ins[i].Flags;
      if (Flags.isByVal()) {
        int FI = MFI.CreateFixedObject(Flags.getByValSize(), VA.getLocMemOffset(), true);
        InVals.push_back(DAG.getFrameIndex(FI, getPointerTy(DAG.getDataLayout())));
        continue;
      }
      unsigned Size = VA.getLocVT().getSizeInBits() / 8;
      int FI = MFI.CreateFixedObject(Size, VA.getLocMemOffset(), true);
      SDValue FIN = DAG.getFrameIndex(FI, MVT::i64);
      Val = DAG.getLoad(VA.getLocVT(), DL, Chain, FIN,
                        MachinePointerInfo::getFixedStack(MF, FI));
    }
    if (VA.getLocInfo() == CCValAssign::SExt)
      Val = DAG.getNode(ISD::AssertSext, DL, VA.getLocVT(), Val,
                        DAG.getValueType(VA.getValVT()));
    else if (VA.getLocInfo() == CCValAssign::ZExt)
      Val = DAG.getNode(ISD::AssertZext, DL, VA.getLocVT(), Val,
                        DAG.getValueType(VA.getValVT()));
    if (VA.getLocInfo() != CCValAssign::Full)
      Val = DAG.getNode(ISD::TRUNCATE, DL, VA.getValVT(), Val);
    InVals.push_back(Val);
  }
  return Chain;
}

SDValue PDP64TargetLowering::LowerCallResult(
    SDValue Chain, SDValue InGlue, CallingConv::ID CallConv, bool IsVarArg,
    const SmallVectorImpl<ISD::InputArg> &Ins, const SDLoc &DL,
    SelectionDAG &DAG, SmallVectorImpl<SDValue> &InVals) const {
  SmallVector<CCValAssign, 16> RVLocs;
  CCState CCInfo(CallConv, IsVarArg, DAG.getMachineFunction(), RVLocs,
                 *DAG.getContext());
  CCInfo.AnalyzeCallResult(Ins, RetCC_PDP64);
  for (CCValAssign &VA : RVLocs) {
    Chain = DAG.getCopyFromReg(Chain, DL, VA.getLocReg(), VA.getLocVT(), InGlue).getValue(1);
    InGlue = Chain.getValue(2);
    SDValue Val = Chain.getValue(0);
    if (VA.getLocInfo() == CCValAssign::SExt)
      Val = DAG.getNode(ISD::AssertSext, DL, VA.getLocVT(), Val,
                        DAG.getValueType(VA.getValVT()));
    else if (VA.getLocInfo() == CCValAssign::ZExt)
      Val = DAG.getNode(ISD::AssertZext, DL, VA.getLocVT(), Val,
                        DAG.getValueType(VA.getValVT()));
    if (VA.getLocInfo() != CCValAssign::Full)
      Val = DAG.getNode(ISD::TRUNCATE, DL, VA.getValVT(), Val);
    InVals.push_back(Val);
  }
  return Chain;
}

SDValue PDP64TargetLowering::LowerCall(CallLoweringInfo &CLI,
                                       SmallVectorImpl<SDValue> &InVals) const {
  SelectionDAG &DAG = CLI.DAG;
  SDLoc &DL = CLI.DL;
  SmallVectorImpl<ISD::OutputArg> &Outs = CLI.Outs;
  SmallVectorImpl<SDValue> &OutVals = CLI.OutVals;
  SmallVectorImpl<ISD::InputArg> &Ins = CLI.Ins;
  SDValue Chain = CLI.Chain;
  SDValue Callee = CLI.Callee;
  CLI.IsTailCall = false;
  CallingConv::ID CallConv = CLI.CallConv;
  bool IsVarArg = CLI.IsVarArg;
  MachineFunction &MF = DAG.getMachineFunction();
  if (IsVarArg)
    report_fatal_error("pdp64: calls of variadic functions are not implemented (stage 1)");

  SmallVector<CCValAssign, 16> ArgLocs;
  CCState CCInfo(CallConv, IsVarArg, MF, ArgLocs, *DAG.getContext());
  CCInfo.AnalyzeCallOperands(Outs, CC_PDP64);
  unsigned NumBytes = CCInfo.getStackSize();

  Chain = DAG.getCALLSEQ_START(Chain, NumBytes, 0, DL);

  SmallVector<std::pair<unsigned, SDValue>, 6> RegsToPass;
  SmallVector<SDValue, 8> MemOpChains;
  SDValue StackPtr;
  for (unsigned i = 0, e = ArgLocs.size(); i != e; ++i) {
    CCValAssign &VA = ArgLocs[i];
    SDValue Arg = OutVals[i];
    ISD::ArgFlagsTy Flags = Outs[i].Flags;
    if (!Flags.isByVal())
      Arg = extendArg(DAG, DL, VA, Flags, Outs[i].ArgVT, Arg);
    if (VA.isRegLoc()) {
      RegsToPass.push_back({VA.getLocReg(), Arg});
      continue;
    }
    assert(VA.isMemLoc());
    if (!StackPtr.getNode())
      StackPtr = DAG.getCopyFromReg(Chain, DL, PDP64::R14, MVT::i64);
    SDValue PtrOff = DAG.getNode(ISD::ADD, DL, MVT::i64, StackPtr,
                                 DAG.getIntPtrConstant(VA.getLocMemOffset(), DL));
    if (Flags.isByVal()) {
      SDValue Size = DAG.getConstant(Flags.getByValSize(), DL, MVT::i64);
      MemOpChains.push_back(DAG.getMemcpy(
          Chain, DL, PtrOff, Arg, Size, Flags.getNonZeroByValAlign(),
          /*isVol=*/false, /*AlwaysInline=*/false, /*CI=*/nullptr, std::nullopt,
          MachinePointerInfo(), MachinePointerInfo()));
    } else {
      MemOpChains.push_back(DAG.getStore(
          Chain, DL, Arg, PtrOff,
          MachinePointerInfo::getStack(MF, VA.getLocMemOffset())));
    }
  }
  if (!MemOpChains.empty())
    Chain = DAG.getNode(ISD::TokenFactor, DL, MVT::Other, MemOpChains);

  SDValue InGlue;
  for (auto &R : RegsToPass) {
    Chain = DAG.getCopyToReg(Chain, DL, R.first, R.second, InGlue);
    InGlue = Chain.getValue(1);
  }

  if (auto *G = dyn_cast<GlobalAddressSDNode>(Callee))
    Callee = DAG.getTargetGlobalAddress(G->getGlobal(), DL, MVT::i64, G->getOffset());
  else if (auto *E = dyn_cast<ExternalSymbolSDNode>(Callee))
    Callee = DAG.getTargetExternalSymbol(E->getSymbol(), MVT::i64);

  SmallVector<SDValue, 8> Ops;
  Ops.push_back(Chain);
  Ops.push_back(Callee);
  for (auto &R : RegsToPass)
    Ops.push_back(DAG.getRegister(R.first, R.second.getValueType()));
  const TargetRegisterInfo *TRI = Subtarget.getRegisterInfo();
  Ops.push_back(DAG.getRegisterMask(TRI->getCallPreservedMask(MF, CallConv)));
  if (InGlue.getNode())
    Ops.push_back(InGlue);

  SDVTList NodeTys = DAG.getVTList(MVT::Other, MVT::Glue);
  Chain = DAG.getNode(PDP64ISD::CALL, DL, NodeTys, Ops);
  InGlue = Chain.getValue(1);
  Chain = DAG.getCALLSEQ_END(Chain, NumBytes, 0, InGlue, DL);
  InGlue = Chain.getValue(1);
  return LowerCallResult(Chain, InGlue, CallConv, IsVarArg, Ins, DL, DAG, InVals);
}

bool PDP64TargetLowering::CanLowerReturn(
    CallingConv::ID CallConv, MachineFunction &MF, bool IsVarArg,
    const SmallVectorImpl<ISD::OutputArg> &Outs, LLVMContext &Context,
    const Type *RetTy) const {
  SmallVector<CCValAssign, 2> RVLocs;
  CCState CCInfo(CallConv, IsVarArg, MF, RVLocs, Context);
  return CCInfo.CheckReturn(Outs, RetCC_PDP64);
}

SDValue PDP64TargetLowering::LowerReturn(
    SDValue Chain, CallingConv::ID CallConv, bool IsVarArg,
    const SmallVectorImpl<ISD::OutputArg> &Outs,
    const SmallVectorImpl<SDValue> &OutVals, const SDLoc &DL,
    SelectionDAG &DAG) const {
  SmallVector<CCValAssign, 2> RVLocs;
  CCState CCInfo(CallConv, IsVarArg, DAG.getMachineFunction(), RVLocs,
                 *DAG.getContext());
  CCInfo.AnalyzeReturn(Outs, RetCC_PDP64);

  SDValue Glue;
  SmallVector<SDValue, 4> RetOps(1, Chain);
  for (unsigned i = 0, e = RVLocs.size(); i != e; ++i) {
    CCValAssign &VA = RVLocs[i];
    SDValue Val = extendArg(DAG, DL, VA, Outs[i].Flags, Outs[i].ArgVT, OutVals[i]);
    Chain = DAG.getCopyToReg(Chain, DL, VA.getLocReg(), Val, Glue);
    Glue = Chain.getValue(1);
    RetOps.push_back(DAG.getRegister(VA.getLocReg(), VA.getLocVT()));
  }
  RetOps[0] = Chain;
  if (Glue.getNode())
    RetOps.push_back(Glue);
  return DAG.getNode(PDP64ISD::RET_GLUE, DL, MVT::Other, RetOps);
}

//===----------------------------------------------------------------------===//
// Custom lowering
//===----------------------------------------------------------------------===//

SDValue PDP64TargetLowering::LowerOperation(SDValue Op, SelectionDAG &DAG) const {
  switch (Op.getOpcode()) {
  case ISD::GlobalAddress:
  case ISD::ExternalSymbol:
  case ISD::JumpTable:
  case ISD::ConstantPool:
  case ISD::BlockAddress:
    return LowerSymbol(Op, DAG);
  case ISD::BR_CC: return LowerBR_CC(Op, DAG);
  case ISD::SELECT_CC: return LowerSELECT_CC(Op, DAG);
  case ISD::SETCC: return LowerSETCC(Op, DAG);
  case ISD::ROTL:
  case ISD::ROTR: return LowerROT(Op, DAG);
  case ISD::BITCAST: return LowerBITCAST(Op, DAG);
  case ISD::VASTART: return LowerVASTART(Op, DAG);
  case ISD::ATOMIC_FENCE: return Op.getOperand(0); // sequential consistency: no instruction
  default:
    llvm_unreachable("unimplemented operation");
  }
}

void PDP64TargetLowering::ReplaceNodeResults(SDNode *N,
                                             SmallVectorImpl<SDValue> &Results,
                                             SelectionDAG &DAG) const {
  SDLoc DL(N);
  if (N->getOpcode() == ISD::BITCAST && N->getValueType(0) == MVT::i32 &&
      N->getOperand(0).getValueType() == MVT::f32) {
    // f32 -> i32: the register already holds the bits (sign-extended)
    SDValue V = DAG.getNode(PDP64ISD::F32_TO_I64, DL, MVT::i64, N->getOperand(0));
    Results.push_back(DAG.getNode(ISD::TRUNCATE, DL, MVT::i32, V));
    return;
  }
  llvm_unreachable("unexpected ReplaceNodeResults");
}

SDValue PDP64TargetLowering::LowerBITCAST(SDValue Op, SelectionDAG &DAG) const {
  SDLoc DL(Op);
  SDValue Src = Op.getOperand(0);
  if (Op.getValueType() == MVT::f32 && Src.getValueType() == MVT::i32) {
    // i32 -> f32: a binary32 is kept sign-extended
    SDValue Wide = DAG.getNode(ISD::ANY_EXTEND, DL, MVT::i64, Src);
    Wide = DAG.getNode(ISD::SIGN_EXTEND_INREG, DL, MVT::i64, Wide,
                       DAG.getValueType(MVT::i32));
    return DAG.getNode(PDP64ISD::I64_TO_F32, DL, MVT::f32, Wide);
  }
  if (Op.getValueType() == MVT::i32 && Src.getValueType() == MVT::f32)
    return SDValue(); // done in ReplaceNodeResults
  return Op;
}

SDValue PDP64TargetLowering::LowerVASTART(SDValue Op, SelectionDAG &DAG) const {
  report_fatal_error("pdp64: va_start is not implemented (stage 1)");
}

SDValue PDP64TargetLowering::LowerSymbol(SDValue Op, SelectionDAG &DAG) const {
  SDLoc DL(Op);
  EVT VT = Op.getValueType();
  SDValue T;
  if (auto *N = dyn_cast<GlobalAddressSDNode>(Op))
    T = DAG.getTargetGlobalAddress(N->getGlobal(), DL, VT, N->getOffset());
  else if (auto *N = dyn_cast<ExternalSymbolSDNode>(Op))
    T = DAG.getTargetExternalSymbol(N->getSymbol(), VT);
  else if (auto *N = dyn_cast<JumpTableSDNode>(Op))
    T = DAG.getTargetJumpTable(N->getIndex(), VT);
  else if (auto *N = dyn_cast<ConstantPoolSDNode>(Op))
    T = DAG.getTargetConstantPool(N->getConstVal(), VT, N->getAlign(), N->getOffset());
  else if (auto *N = dyn_cast<BlockAddressSDNode>(Op))
    T = DAG.getTargetBlockAddress(N->getBlockAddress(), VT, N->getOffset());
  else
    llvm_unreachable("not a symbol");
  return DAG.getNode(PDP64ISD::WRAPPER, DL, VT, T);
}

static PDP64CC::CondCode intCC(ISD::CondCode CC) {
  switch (CC) {
  case ISD::SETEQ: return PDP64CC::COND_eq;
  case ISD::SETNE: return PDP64CC::COND_ne;
  case ISD::SETLT: return PDP64CC::COND_lt;
  case ISD::SETGE: return PDP64CC::COND_ge;
  case ISD::SETGT: return PDP64CC::COND_gt;
  case ISD::SETLE: return PDP64CC::COND_le;
  case ISD::SETULT: return PDP64CC::COND_cs;
  case ISD::SETUGE: return PDP64CC::COND_cc;
  case ISD::SETUGT: return PDP64CC::COND_hi;
  case ISD::SETULE: return PDP64CC::COND_los;
  default: llvm_unreachable("not an integer condition");
  }
}

// A floating-point condition as the machine's: the PDP64CC condition, and whether the operands are swapped (a > b is b < a).  Every
// predicate of LLVM is one of ten, none needs a "not less than" (see PDP64.h).
static PDP64CC::CondCode fpCC(ISD::CondCode CC, bool &Swap) {
  Swap = false;
  switch (CC) {
  case ISD::SETEQ: case ISD::SETOEQ: return PDP64CC::FCC_EQ;
  case ISD::SETNE: case ISD::SETUNE: return PDP64CC::FCC_NE;
  case ISD::SETLT: case ISD::SETOLT: return PDP64CC::FCC_LT;
  case ISD::SETLE: case ISD::SETOLE: return PDP64CC::FCC_LE;
  case ISD::SETGT: case ISD::SETOGT: Swap = true; return PDP64CC::FCC_LT;
  case ISD::SETGE: case ISD::SETOGE: Swap = true; return PDP64CC::FCC_LE;
  case ISD::SETULT: return PDP64CC::FCC_ULT;
  case ISD::SETULE: return PDP64CC::FCC_ULE;
  case ISD::SETUGT: Swap = true; return PDP64CC::FCC_ULT;
  case ISD::SETUGE: Swap = true; return PDP64CC::FCC_ULE;
  case ISD::SETUEQ: return PDP64CC::FCC_UEQ;
  case ISD::SETONE: return PDP64CC::FCC_ONE;
  case ISD::SETO: return PDP64CC::FCC_OR;
  case ISD::SETUO: return PDP64CC::FCC_UO;
  default: llvm_unreachable("not a floating-point condition");
  }
}

// operands of the compare node: swap a constant to the right
static void normalizeCmp(SDValue &LHS, SDValue &RHS, ISD::CondCode &CC) {
  if (isa<ConstantSDNode>(LHS) && !isa<ConstantSDNode>(RHS)) {
    std::swap(LHS, RHS);
    CC = ISD::getSetCCSwappedOperands(CC);
  }
}

// the condition and operands of a compare node, integer or floating point
static unsigned compareCC(SDValue &LHS, SDValue &RHS, ISD::CondCode CC) {
  if (LHS.getValueType().isFloatingPoint()) {
    bool Swap;
    unsigned PC = fpCC(CC, Swap);
    if (Swap)
      std::swap(LHS, RHS);
    return PC;
  }
  return intCC(CC);
}

SDValue PDP64TargetLowering::LowerBR_CC(SDValue Op, SelectionDAG &DAG) const {
  SDValue Chain = Op.getOperand(0);
  ISD::CondCode CC = cast<CondCodeSDNode>(Op.getOperand(1))->get();
  SDValue LHS = Op.getOperand(2), RHS = Op.getOperand(3), Dest = Op.getOperand(4);
  SDLoc DL(Op);
  normalizeCmp(LHS, RHS, CC);
  unsigned PC = compareCC(LHS, RHS, CC);
  return DAG.getNode(PDP64ISD::BR_CC, DL, MVT::Other, Chain, LHS, RHS,
                     DAG.getTargetConstant(PC, DL, MVT::i64), Dest);
}

// an integer compare as a value: one setCC (rd = 1 or 0).  A constant just out of the signed 8-bit range may be in range with the neighbouring
// condition (x < 128 is x <= 127; the unsigned ones when nothing wraps); otherwise it goes into a register.
static SDValue makeIntSetCC(SelectionDAG &DAG, const SDLoc &DL, EVT VT, SDValue LHS, SDValue RHS, ISD::CondCode CC) {
  normalizeCmp(LHS, RHS, CC);
  if (auto *C = dyn_cast<ConstantSDNode>(RHS)) {
    int64_t V = C->getSExtValue();
    if (!isInt<8>(V)) {
      uint64_t U = C->getZExtValue();
      int64_t NV = 0;
      ISD::CondCode NC = CC;
      bool Ok = true;
      switch (CC) {
      case ISD::SETLT: NC = ISD::SETLE; NV = V - 1; Ok = V != INT64_MIN; break;
      case ISD::SETGE: NC = ISD::SETGT; NV = V - 1; Ok = V != INT64_MIN; break;
      case ISD::SETLE: NC = ISD::SETLT; NV = V + 1; Ok = V != INT64_MAX; break;
      case ISD::SETGT: NC = ISD::SETGE; NV = V + 1; Ok = V != INT64_MAX; break;
      case ISD::SETULT: NC = ISD::SETULE; NV = U - 1; Ok = U != 0; break;
      case ISD::SETUGE: NC = ISD::SETUGT; NV = U - 1; Ok = U != 0; break;
      case ISD::SETULE: NC = ISD::SETULT; NV = U + 1; Ok = U != UINT64_MAX; break;
      case ISD::SETUGT: NC = ISD::SETUGE; NV = U + 1; Ok = U != UINT64_MAX; break;
      default: Ok = false;
      }
      if (Ok && isInt<8>(NV)) {
        RHS = DAG.getConstant(NV, DL, MVT::i64);
        CC = NC;
      }
    }
  }
  return DAG.getNode(PDP64ISD::SETCC, DL, VT, LHS, RHS, DAG.getTargetConstant(intCC(CC), DL, MVT::i64));
}

SDValue PDP64TargetLowering::LowerSELECT_CC(SDValue Op, SelectionDAG &DAG) const {
  SDValue LHS = Op.getOperand(0), RHS = Op.getOperand(1);
  SDValue TV = Op.getOperand(2), FV = Op.getOperand(3);
  ISD::CondCode CC = cast<CondCodeSDNode>(Op.getOperand(4))->get();
  SDLoc DL(Op);
  EVT VT = Op.getValueType();
  normalizeCmp(LHS, RHS, CC);
  // select of the constants 1 and 0 (or 0 and 1) on an integer compare is the compare itself: one setCC
  if (VT == MVT::i64 && !LHS.getValueType().isFloatingPoint()) {
    auto *T = dyn_cast<ConstantSDNode>(TV);
    auto *F = dyn_cast<ConstantSDNode>(FV);
    if (T && F && T->isOne() && F->isZero())
      return makeIntSetCC(DAG, DL, VT, LHS, RHS, CC);
    if (T && F && T->isZero() && F->isOne())
      return makeIntSetCC(DAG, DL, VT, LHS, RHS, ISD::getSetCCInverse(CC, LHS.getValueType()));
  }
  unsigned PC = compareCC(LHS, RHS, CC);
  return DAG.getNode(PDP64ISD::SELECT_CC, DL, VT, LHS, RHS,
                     DAG.getTargetConstant(PC, DL, MVT::i64), TV, FV);
}

// a comparison used as a value: one setCC for integers; for floating point a branch over a constant (the custom inserter of SETF_*)
SDValue PDP64TargetLowering::LowerSETCC(SDValue Op, SelectionDAG &DAG) const {
  SDValue LHS = Op.getOperand(0), RHS = Op.getOperand(1);
  ISD::CondCode CC = cast<CondCodeSDNode>(Op.getOperand(2))->get();
  SDLoc DL(Op);
  EVT VT = Op.getValueType();
  if (!LHS.getValueType().isFloatingPoint())
    return makeIntSetCC(DAG, DL, VT, LHS, RHS, CC);
  unsigned PC = compareCC(LHS, RHS, CC);
  return DAG.getNode(PDP64ISD::FSETCC, DL, VT, LHS, RHS, DAG.getTargetConstant(PC, DL, MVT::i64));
}

SDValue PDP64TargetLowering::LowerROT(SDValue Op, SelectionDAG &DAG) const {
  if (auto *C = dyn_cast<ConstantSDNode>(Op.getOperand(1)))
    if (C->getZExtValue() < 64)
      return Op; // ror / rol with an immediate
  return expandROT(Op.getNode(), /*AllowVectorOps=*/false, DAG);
}

//===----------------------------------------------------------------------===//
// Custom inserters: the conditions that are not one instruction
//===----------------------------------------------------------------------===//

MachineBasicBlock *PDP64TargetLowering::emitSelect(MachineInstr &MI,
                                                   MachineBasicBlock *BB) const {
  const TargetInstrInfo &TII = *Subtarget.getInstrInfo();
  DebugLoc DL = MI.getDebugLoc();
  MachineFunction *F = BB->getParent();
  const BasicBlock *LLVM_BB = BB->getBasicBlock();
  MachineFunction::iterator It = ++BB->getIterator();
  MachineRegisterInfo &MRI = F->getRegInfo();

  //  BB:       branch to sink if the condition holds (the value is TV)
  //  copy0:    (falls through; the value is FV)
  //  sink:     rd = phi [FV, copy0], [TV, BB]
  MachineBasicBlock *Copy0 = F->CreateMachineBasicBlock(LLVM_BB);
  MachineBasicBlock *Sink = F->CreateMachineBasicBlock(LLVM_BB);
  F->insert(It, Copy0);
  F->insert(It, Sink);
  Sink->splice(Sink->begin(), BB, std::next(MachineBasicBlock::iterator(MI)), BB->end());
  Sink->transferSuccessorsAndUpdatePHIs(BB);
  BB->addSuccessor(Copy0);
  BB->addSuccessor(Sink);
  Copy0->addSuccessor(Sink);

  unsigned Opc = MI.getOpcode();
  Register Rd = MI.getOperand(0).getReg();
  if (Opc == PDP64::SETF_D || Opc == PDP64::SETF_S) {
    // rd = (a CC b) ? 1 : 0:  the constant for the taken branch is made in BB, the other in copy0:
    //     movq #1, t ; fcbCC a, b, sink ; clr f ; sink:      (a condition that needs two branches is negated: clr, fcbCC', movq #1)
    Register A = MI.getOperand(1).getReg(), B = MI.getOperand(2).getReg();
    unsigned CC = MI.getOperand(3).getImm();
    unsigned Taken = 1;
    if (CC == PDP64CC::FCC_ULT || CC == PDP64CC::FCC_ULE) {
      bool Swap;
      CC = PDP64CC::fpInvert((PDP64CC::CondCode)CC, Swap);
      if (Swap)
        std::swap(A, B);
      Taken = 0;
    }
    Register T = MRI.createVirtualRegister(&PDP64::GPRRegClass);
    Register FV = MRI.createVirtualRegister(&PDP64::GPRRegClass);
    if (Taken)
      BuildMI(BB, DL, TII.get(PDP64::MOVI), T).addImm(1);
    else
      BuildMI(BB, DL, TII.get(PDP64::CLR), T);
    BuildMI(BB, DL, TII.get(Opc == PDP64::SETF_S ? PDP64::FCB_S : PDP64::FCB_D))
        .addReg(A).addReg(B).addImm(CC).addMBB(Sink);
    if (Taken)
      BuildMI(Copy0, DL, TII.get(PDP64::CLR), FV);
    else
      BuildMI(Copy0, DL, TII.get(PDP64::MOVI), FV).addImm(1);
    BuildMI(*Sink, Sink->begin(), DL, TII.get(PDP64::PHI), Rd)
        .addReg(FV).addMBB(Copy0)
        .addReg(T).addMBB(BB);
    MI.eraseFromParent();
    return Sink;
  }
  Register TV = MI.getOperand(4).getReg(), FV = MI.getOperand(5).getReg();
  if (Opc == PDP64::SEL_RR || Opc == PDP64::SEL_RI) {
    BuildMI(BB, DL, TII.get(Opc == PDP64::SEL_RR ? PDP64::CB_rr : PDP64::CB_ri))
        .addReg(MI.getOperand(1).getReg())
        .add(MI.getOperand(2))
        .add(MI.getOperand(3))
        .addMBB(Sink);
  } else {
    // a floating-point condition of two branches (a<b or unordered, a<=b or unordered) is one branch, negated, with the arms swapped
    Register A = MI.getOperand(1).getReg(), B = MI.getOperand(2).getReg();
    unsigned CC = MI.getOperand(3).getImm();
    if (CC == PDP64CC::FCC_ULT || CC == PDP64CC::FCC_ULE) {
      bool Swap;
      CC = PDP64CC::fpInvert((PDP64CC::CondCode)CC, Swap);
      if (Swap)
        std::swap(A, B);
      std::swap(TV, FV);
    }
    BuildMI(BB, DL, TII.get(Opc == PDP64::SEL_FS ? PDP64::FCB_S : PDP64::FCB_D))
        .addReg(A).addReg(B).addImm(CC).addMBB(Sink);
  }
  BuildMI(*Sink, Sink->begin(), DL, TII.get(PDP64::PHI), Rd)
      .addReg(FV).addMBB(Copy0)
      .addReg(TV).addMBB(BB);
  MI.eraseFromParent();
  return Sink;
}

MachineBasicBlock *
PDP64TargetLowering::EmitInstrWithCustomInserter(MachineInstr &MI,
                                                 MachineBasicBlock *BB) const {
  switch (MI.getOpcode()) {
  case PDP64::SEL_RR:
  case PDP64::SEL_RI:
  case PDP64::SEL_FD:
  case PDP64::SEL_FS:
  case PDP64::SETF_D:
  case PDP64::SETF_S:
    return emitSelect(MI, BB);
  default:
    llvm_unreachable("unexpected instruction for the custom inserter");
  }
}

TargetLowering::ConstraintType
PDP64TargetLowering::getConstraintType(StringRef Constraint) const {
  if (Constraint.size() == 1 && Constraint[0] == 'r')
    return C_RegisterClass;
  return TargetLowering::getConstraintType(Constraint);
}

std::pair<unsigned, const TargetRegisterClass *>
PDP64TargetLowering::getRegForInlineAsmConstraint(const TargetRegisterInfo *TRI,
                                                  StringRef Constraint,
                                                  MVT VT) const {
  if (Constraint.size() == 1 && Constraint[0] == 'r')
    return std::make_pair(0U, &PDP64::GPRRegClass);
  return TargetLowering::getRegForInlineAsmConstraint(TRI, Constraint, VT);
}

// the read-modify-write operations the machine has as instructions (swap, add, and, or, xor, the signed and unsigned maximum and
// minimum; sub is an add of the negation, made by the legalizer); the rest are a compare-and-swap loop
TargetLowering::AtomicExpansionKind
PDP64TargetLowering::shouldExpandAtomicRMWInIR(AtomicRMWInst *AI) const {
  if (AI->getType()->getPrimitiveSizeInBits() < 32) // a byte or a half: LLVM's partword expansion on the 4-byte compare and swap
    return AtomicExpansionKind::CmpXChg;
  switch (AI->getOperation()) {
  case AtomicRMWInst::Xchg:
  case AtomicRMWInst::Add:
  case AtomicRMWInst::Sub:
  case AtomicRMWInst::And:
  case AtomicRMWInst::Or:
  case AtomicRMWInst::Xor:
  case AtomicRMWInst::Max:
  case AtomicRMWInst::Min:
  case AtomicRMWInst::UMax:
  case AtomicRMWInst::UMin:
    return AtomicExpansionKind::None;
  default:
    return AtomicExpansionKind::CmpXChg;
  }
}
