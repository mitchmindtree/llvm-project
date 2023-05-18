//===-- FuelVMTargetMachine.cpp - Define TargetMachine for FuelVM ---------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// Top-level implementation for the FuelVM target.
//
//===----------------------------------------------------------------------===//

#include "FuelVMTargetMachine.h"
#include "FuelVM.h"
#include "FuelVMMachineFunctionInfo.h"
#include "TargetInfo/FuelVMTargetInfo.h"
#include "llvm/CodeGen/Passes.h"
#include "llvm/CodeGen/TargetLoweringObjectFileImpl.h"
#include "llvm/CodeGen/TargetPassConfig.h"
#include "llvm/MC/MCAsmInfo.h"
#include "llvm/MC/TargetRegistry.h"
#include <optional>
using namespace llvm;

extern "C" LLVM_EXTERNAL_VISIBILITY void LLVMInitializeFuelVMTarget() {
  // Register the target.
  RegisterTargetMachine<FuelVMTargetMachine> X(getTheFuelVMTarget());
  PassRegistry &PR = *PassRegistry::getPassRegistry();
  initializeFuelVMDAGToDAGISelPass(PR);
}

static Reloc::Model getEffectiveRelocModel(std::optional<Reloc::Model> RM) {
  return RM.value_or(Reloc::Static);
}

// TODO: Remove unnecessary args.
static std::string computeDataLayout(const Triple &TT, StringRef CPU,
                                     const TargetOptions &Options) {
  // FuelVM interprets immediates as big-endian.
  std::string Layout = "E";
  // ELF-style mangling.
  Layout += "-m:e";
  // 64-bit pointers, ABI matches.
  Layout += "-p:64:64";
  return Layout;
}

FuelVMTargetMachine::FuelVMTargetMachine(const Target &T, const Triple &TT,
                                         StringRef CPU, StringRef FS,
                                         const TargetOptions &Options,
                                         std::optional<Reloc::Model> RM,
                                         std::optional<CodeModel::Model> CM,
                                         CodeGenOpt::Level OL, bool JIT)
    : LLVMTargetMachine(T, computeDataLayout(TT, CPU, Options), TT, CPU, FS,
                        Options, getEffectiveRelocModel(RM),
                        getEffectiveCodeModel(CM, CodeModel::Small), OL),
      TLOF(std::make_unique<TargetLoweringObjectFileELF>()),
      Subtarget(TT, std::string(CPU), std::string(FS), *this) {
  initAsmInfo();
}

FuelVMTargetMachine::~FuelVMTargetMachine() = default;

namespace {
/// FuelVM Code Generator Pass Configuration Options.
class FuelVMPassConfig : public TargetPassConfig {
public:
  FuelVMPassConfig(FuelVMTargetMachine &TM, PassManagerBase &PM)
    : TargetPassConfig(TM, PM) {}

  FuelVMTargetMachine &getFuelVMTargetMachine() const {
    return getTM<FuelVMTargetMachine>();
  }

  bool addInstSelector() override;
  void addPreEmitPass() override;
};
} // namespace

TargetPassConfig *FuelVMTargetMachine::createPassConfig(PassManagerBase &PM) {
  return new FuelVMPassConfig(*this, PM);
}

MachineFunctionInfo *FuelVMTargetMachine::createMachineFunctionInfo(
    BumpPtrAllocator &Allocator, const Function &F,
    const TargetSubtargetInfo *STI) const {
  return FuelVMMachineFunctionInfo::create<FuelVMMachineFunctionInfo>(Allocator,
                                                                      F, STI);
}

bool FuelVMPassConfig::addInstSelector() {
  // Install an instruction selector.
  addPass(createFuelVMISelDag(getFuelVMTargetMachine(), getOptLevel()));
  return false;
}

void FuelVMPassConfig::addPreEmitPass() {
  // Must run branch selection immediately preceding the asm printer.
  addPass(createFuelVMBranchSelectionPass());
}