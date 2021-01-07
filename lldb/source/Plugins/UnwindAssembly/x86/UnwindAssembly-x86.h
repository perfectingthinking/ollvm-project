//===-- UnwindAssembly-x86.h ------------------------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef liblldb_UnwindAssembly_x86_h_
#define liblldb_UnwindAssembly_x86_h_

#include "x86AssemblyInspectionEngine.h"

#include "lldb/Target/UnwindAssembly.h"
#include "lldb/lldb-private.h"

class UnwindAssembly_x86 : public lldb_private::UnwindAssembly {
public:
  ~UnwindAssembly_x86() override;

  bool GetNonCallSiteUnwindPlanFromAssembly(
      lldb_private::AddressRange &func, lldb_private::Thread &thread,
      lldb_private::UnwindPlan &unwind_plan) override;

  bool
  AugmentUnwindPlanFromCallSite(lldb_private::AddressRange &func,
                                lldb_private::Thread &thread,
                                lldb_private::UnwindPlan &unwind_plan) override;

  bool GetFastUnwindPlan(lldb_private::AddressRange &func,
                         lldb_private::Thread &thread,
                         lldb_private::UnwindPlan &unwind_plan) override;

  // thread may be NULL in which case we only use the Target (e.g. if this is
  // called pre-process-launch).
  bool
  FirstNonPrologueInsn(lldb_private::AddressRange &func,
                       const lldb_private::ExecutionContext &exe_ctx,
                       lldb_private::Address &first_non_prologue_insn) override;

  static lldb_private::UnwindAssembly *
  CreateInstance(const lldb_private::ArchSpec &arch);

  // PluginInterface protocol
  static void Initialize();

  static void Terminate();

  static lldb_private::ConstString GetPluginNameStatic();

  static const char *GetPluginDescriptionStatic();

  lldb_private::ConstString GetPluginName() override;

  uint32_t GetPluginVersion() override;

private:
  UnwindAssembly_x86(const lldb_private::ArchSpec &arch);

  lldb_private::ArchSpec m_arch;

  lldb_private::x86AssemblyInspectionEngine *m_assembly_inspection_engine;
};

#endif // liblldb_UnwindAssembly_x86_h_