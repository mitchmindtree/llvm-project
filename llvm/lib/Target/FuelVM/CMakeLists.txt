add_llvm_component_group(FuelVM)

set(LLVM_TARGET_DEFINITIONS FuelVM.td)

# tablegen(LLVM FuelVMGenAsmMatcher.inc -gen-asm-matcher)
# tablegen(LLVM FuelVMGenAsmWriter.inc -gen-asm-writer)
# tablegen(LLVM FuelVMGenCallingConv.inc -gen-callingconv)
# tablegen(LLVM FuelVMGenDAGISel.inc -gen-dag-isel)
# tablegen(LLVM FuelVMGenDisassemblerTables.inc -gen-disassembler)
# tablegen(LLVM FuelVMGenInstrInfo.inc -gen-instr-info)
# tablegen(LLVM FuelVMGenMCCodeEmitter.inc -gen-emitter)
# tablegen(LLVM FuelVMGenRegisterInfo.inc -gen-register-info)
# tablegen(LLVM FuelVMGenSubtargetInfo.inc -gen-subtarget)

# add_public_tablegen_target(FuelVMCommonTableGen)

add_llvm_target(FuelVMCodeGen
  # FuelVMBranchSelector.cpp
  # FuelVMISelDAGToDAG.cpp
  # FuelVMISelLowering.cpp
  # FuelVMInstrInfo.cpp
  # FuelVMFrameLowering.cpp
  # FuelVMMachineFunctionInfo.cpp
  # FuelVMRegisterInfo.cpp
  # FuelVMSubtarget.cpp
  FuelVMTargetMachine.cpp
  # FuelVMAsmPrinter.cpp
  # FuelVMMCInstLower.cpp

  LINK_COMPONENTS
  # AsmPrinter
  CodeGen
  # Core
  # MC
  # FuelVMDesc
  # FuelVMInfo
  # SelectionDAG
  # Support
  Target

  ADD_TO_COMPONENT
  FuelVM
  )

# add_subdirectory(MCTargetDesc)
# add_subdirectory(TargetInfo)
# add_subdirectory(AsmParser)
# add_subdirectory(Disassembler)
