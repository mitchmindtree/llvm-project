//===-- Map from signal numbers to strings ----------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIBC_SRC_SUPPORT_STRING_UTIL_TABLES_SIGNAL_TABLE_H
#define LLVM_LIBC_SRC_SUPPORT_STRING_UTIL_TABLES_SIGNAL_TABLE_H

#include "src/__support/StringUtil/message_mapper.h"

#include "posix_signal_table.h"
#include "stdc_signal_table.h"

#if defined(__linux__) || defined(__Fuchsia__)
#define USE_LINUX_PLATFORM_SIGNALS 1
#else
#define USE_LINUX_PLATFORM_SIGNALS 0
#endif

#if USE_LINUX_PLATFORM_SIGNALS
#include "linux/signal_table.h"
#endif

namespace __llvm_libc::internal {

inline constexpr auto PLATFORM_SIGNALS = []() {
  if constexpr (USE_LINUX_PLATFORM_SIGNALS) {
    return STDC_SIGNALS + POSIX_SIGNALS + LINUX_SIGNALS;
  } else {
    return STDC_SIGNALS;
  }
}();

} // namespace __llvm_libc::internal

#endif // LLVM_LIBC_SRC_SUPPORT_STRING_UTIL_TABLES_SIGNAL_TABLE_H
