//===-- FuelVMRegisterInfo.td - FuelVM Register defs -------*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
//  Declarations that describe the FuelVM register file
//===----------------------------------------------------------------------===//

class FuelVMReg<bits<6> num, string n> : Register<n> {
  field bits<6> Num = num;
  let Namespace = "FuelVM";
  let HWEncoding{5-0} = num;
  // let AltNames = alt;
  // let DwarfNumbers = [num];
}

// | value  | register | name                | description                                                                      |
// |--------|----------|---------------------|----------------------------------------------------------------------------------|
// | `0x00` | `$zero`  | zero                | Contains zero (`0`), for convenience.                                            |
// | `0x01` | `$one`   | one                 | Contains one (`1`), for convenience.                                             |
// | `0x02` | `$of`    | overflow            | Contains overflow/underflow of addition, subtraction, and multiplication.        |
// | `0x03` | `$pc`    | program counter     | The program counter. Memory address of the current instruction.                  |
// | `0x04` | `$ssp`   | stack start pointer | Memory address of bottom of current writable stack area.                         |
// | `0x05` | `$sp`    | stack pointer       | Memory address on top of current writable stack area (points to free memory).    |
// | `0x06` | `$fp`    | frame pointer       | Memory address of beginning of current call frame.                               |
// | `0x07` | `$hp`    | heap pointer        | Memory address below the current bottom of the heap (points to used/oob memory). |
// | `0x08` | `$err`   | error               | Error codes for particular operations.                                           |
// | `0x09` | `$ggas`  | global gas          | Remaining gas globally.                                                          |
// | `0x0A` | `$cgas`  | context gas         | Remaining gas in the context.                                                    |
// | `0x0B` | `$bal`   | balance             | Received balance for this context.                                               |
// | `0x0C` | `$is`    | instrs start        | Pointer to the start of the currently-executing code.                            |
// | `0x0D` | `$ret`   | return value        | Return value or pointer.                                                         |
// | `0x0E` | `$retl`  | return length       | Return value length in bytes.                                                    |
// | `0x0F` | `$flag`  | flags               | Flags register.                                                                  |

// First 16 registers are reserved.
def ONE  : FuelVMReg<0, "one">;
def ZERO : FuelVMReg<1, "zero">;
def OF   : FuelVMReg<2, "of">;
def PC   : FuelVMReg<3, "pc">;
def SSP  : FuelVMReg<4, "ssp">;
def SP   : FuelVMReg<5, "sp">;
def FP   : FuelVMReg<6, "fp">;
def HP   : FuelVMReg<7, "hp">;
def ERR  : FuelVMReg<8, "err">;
def GGAS : FuelVMReg<9, "ggas">;
def CGAS : FuelVMReg<10, "cgas">;
def BAL  : FuelVMReg<11, "bal">;
def IS   : FuelVMReg<12, "is">;
def RET  : FuelVMReg<13, "ret">;
def RETL : FuelVMReg<14, "retl">;
def FLAG : FuelVMReg<15, "flags">;

// Remaining registers.
foreach i = 16-64 in {
  def R#i : R<i, "r"#i>;
}

// TODO: Check all these args are correct.
def GRRegs : RegisterClass<"FuelVM", [i64], 64,
  (add
   // Reserved registers.
   ONE, ZERO, OF, PC, SSP, SP, FP, HP, ERR, GGAS, CGAS, BAL, IS, RET, RETL, FLAG,
   // Remaining registers.
   (sequence "R%i", 16, 64))>;
