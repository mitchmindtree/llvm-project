//===-- FuelVM.td - Describe the FuelVM Target Machine -----*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
// This is the top level entry point for the FuelVM target.
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
// Target-independent interfaces
//===----------------------------------------------------------------------===//

include "llvm/Target/Target.td"

//===----------------------------------------------------------------------===//
// Subtarget Features. 
//===----------------------------------------------------------------------===//

// For now, no subtargets!

//===----------------------------------------------------------------------===//
// FuelVM supported processors.
//===----------------------------------------------------------------------===//
class Proc<string Name, list<SubtargetFeature> Features>
 : Processor<Name, NoItineraries, Features>;

def : Proc<"generic", []>;
def : Proc<"fuelvm",  []>;

//===----------------------------------------------------------------------===//
// Register File Description
//===----------------------------------------------------------------------===//

// include "FuelVMRegisterInfo.td"

//===----------------------------------------------------------------------===//
// Calling Convention Description
//===----------------------------------------------------------------------===//

// include "FuelVMCallingConv.td"

//===----------------------------------------------------------------------===//
// Instruction Descriptions
//===----------------------------------------------------------------------===//

// include "FuelVMInstrInfo.td"

// def FuelVMInstrInfo : InstrInfo;

//===---------------------------------------------------------------------===//
// Assembly Printers
//===---------------------------------------------------------------------===//

// def FuelVMAsmWriter : AsmWriter {
//   string AsmWriterClassName = "InstPrinter";
// }

//===---------------------------------------------------------------------===//
// Assembly Parsers
//===---------------------------------------------------------------------===//

// def FuelVMAsmParser : AsmParser {
//   let AllowDuplicateRegisterNames = 1;
//   let ShouldEmitMatchRegisterAltName = 1;
// }

//===----------------------------------------------------------------------===//
// Target Declaration
//===----------------------------------------------------------------------===//

// def FuelVM : Target {
//   let InstructionSet = FuelVMInstrInfo;
//   let AssemblyParsers = [FuelVMAsmParser];
// }

