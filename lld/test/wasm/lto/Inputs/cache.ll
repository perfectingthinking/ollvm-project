target datalayout = "e-m:e-p:32:32-i64:64-n32:64-S128"
target triple = "wasm32-unknown-unknown"

define i32 @_start() {
entry:
  call void (...) @globalfunc()
  ret i32 0
}

declare void @globalfunc(...)