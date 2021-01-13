; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -vector-combine -S -mtriple=x86_64-- -mattr=SSE2 | FileCheck %s --check-prefixes=CHECK,SSE
; RUN: opt < %s -vector-combine -S -mtriple=x86_64-- -mattr=AVX2 | FileCheck %s --check-prefixes=CHECK,AVX

define i1 @cmp_v4i32(<4 x float> %arg, <4 x float> %arg1) {
; CHECK-LABEL: @cmp_v4i32(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    [[T:%.*]] = bitcast <4 x float> [[ARG:%.*]] to <4 x i32>
; CHECK-NEXT:    [[T3:%.*]] = bitcast <4 x float> [[ARG1:%.*]] to <4 x i32>
; CHECK-NEXT:    [[TMP0:%.*]] = icmp eq <4 x i32> [[T]], [[T3]]
; CHECK-NEXT:    [[T5:%.*]] = extractelement <4 x i1> [[TMP0]], i32 0
; CHECK-NEXT:    br i1 [[T5]], label [[BB6:%.*]], label [[BB18:%.*]]
; CHECK:       bb6:
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq <4 x i32> [[T]], [[T3]]
; CHECK-NEXT:    [[T9:%.*]] = extractelement <4 x i1> [[TMP1]], i32 1
; CHECK-NEXT:    br i1 [[T9]], label [[BB10:%.*]], label [[BB18]]
; CHECK:       bb10:
; CHECK-NEXT:    [[TMP2:%.*]] = icmp eq <4 x i32> [[T]], [[T3]]
; CHECK-NEXT:    [[T13:%.*]] = extractelement <4 x i1> [[TMP2]], i32 2
; CHECK-NEXT:    br i1 [[T13]], label [[BB14:%.*]], label [[BB18]]
; CHECK:       bb14:
; CHECK-NEXT:    [[TMP3:%.*]] = icmp eq <4 x i32> [[T]], [[T3]]
; CHECK-NEXT:    [[T17:%.*]] = extractelement <4 x i1> [[TMP3]], i32 3
; CHECK-NEXT:    br label [[BB18]]
; CHECK:       bb18:
; CHECK-NEXT:    [[T19:%.*]] = phi i1 [ false, [[BB10]] ], [ false, [[BB6]] ], [ false, [[BB:%.*]] ], [ [[T17]], [[BB14]] ]
; CHECK-NEXT:    ret i1 [[T19]]
;
bb:
  %t = bitcast <4 x float> %arg to <4 x i32>
  %t2 = extractelement <4 x i32> %t, i32 0
  %t3 = bitcast <4 x float> %arg1 to <4 x i32>
  %t4 = extractelement <4 x i32> %t3, i32 0
  %t5 = icmp eq i32 %t2, %t4
  br i1 %t5, label %bb6, label %bb18

bb6:
  %t7 = extractelement <4 x i32> %t, i32 1
  %t8 = extractelement <4 x i32> %t3, i32 1
  %t9 = icmp eq i32 %t7, %t8
  br i1 %t9, label %bb10, label %bb18

bb10:
  %t11 = extractelement <4 x i32> %t, i32 2
  %t12 = extractelement <4 x i32> %t3, i32 2
  %t13 = icmp eq i32 %t11, %t12
  br i1 %t13, label %bb14, label %bb18

bb14:
  %t15 = extractelement <4 x i32> %t, i32 3
  %t16 = extractelement <4 x i32> %t3, i32 3
  %t17 = icmp eq i32 %t15, %t16
  br label %bb18

bb18:
  %t19 = phi i1 [ false, %bb10 ], [ false, %bb6 ], [ false, %bb ], [ %t17, %bb14 ]
  ret i1 %t19
}

define i32 @cmp_v2f64(<2 x double> %x, <2 x double> %y, <2 x double> %z) {
; SSE-LABEL: @cmp_v2f64(
; SSE-NEXT:  entry:
; SSE-NEXT:    [[X1:%.*]] = extractelement <2 x double> [[X:%.*]], i32 1
; SSE-NEXT:    [[Y1:%.*]] = extractelement <2 x double> [[Y:%.*]], i32 1
; SSE-NEXT:    [[CMP1:%.*]] = fcmp oeq double [[X1]], [[Y1]]
; SSE-NEXT:    br i1 [[CMP1]], label [[T:%.*]], label [[F:%.*]]
; SSE:       t:
; SSE-NEXT:    [[Z1:%.*]] = extractelement <2 x double> [[Z:%.*]], i32 1
; SSE-NEXT:    [[CMP2:%.*]] = fcmp ogt double [[Y1]], [[Z1]]
; SSE-NEXT:    [[E:%.*]] = select i1 [[CMP2]], i32 42, i32 99
; SSE-NEXT:    ret i32 [[E]]
; SSE:       f:
; SSE-NEXT:    ret i32 0
;
; AVX-LABEL: @cmp_v2f64(
; AVX-NEXT:  entry:
; AVX-NEXT:    [[TMP0:%.*]] = fcmp oeq <2 x double> [[X:%.*]], [[Y:%.*]]
; AVX-NEXT:    [[CMP1:%.*]] = extractelement <2 x i1> [[TMP0]], i32 1
; AVX-NEXT:    br i1 [[CMP1]], label [[T:%.*]], label [[F:%.*]]
; AVX:       t:
; AVX-NEXT:    [[TMP1:%.*]] = fcmp ogt <2 x double> [[Y]], [[Z:%.*]]
; AVX-NEXT:    [[CMP2:%.*]] = extractelement <2 x i1> [[TMP1]], i32 1
; AVX-NEXT:    [[E:%.*]] = select i1 [[CMP2]], i32 42, i32 99
; AVX-NEXT:    ret i32 [[E]]
; AVX:       f:
; AVX-NEXT:    ret i32 0
;
entry:
  %x1 = extractelement <2 x double> %x, i32 1
  %y1 = extractelement <2 x double> %y, i32 1
  %cmp1 = fcmp oeq double %x1, %y1
  br i1 %cmp1, label %t, label %f

t:
  %z1 = extractelement <2 x double> %z, i32 1
  %cmp2 = fcmp ogt double %y1, %z1
  %e = select i1 %cmp2, i32 42, i32 99
  ret i32 %e

f:
  ret i32 0
}

define i1 @cmp01_v2f64(<2 x double> %x, <2 x double> %y) {
; SSE-LABEL: @cmp01_v2f64(
; SSE-NEXT:    [[X0:%.*]] = extractelement <2 x double> [[X:%.*]], i32 0
; SSE-NEXT:    [[Y1:%.*]] = extractelement <2 x double> [[Y:%.*]], i32 1
; SSE-NEXT:    [[CMP:%.*]] = fcmp oge double [[X0]], [[Y1]]
; SSE-NEXT:    ret i1 [[CMP]]
;
; AVX-LABEL: @cmp01_v2f64(
; AVX-NEXT:    [[SHIFT:%.*]] = shufflevector <2 x double> [[Y:%.*]], <2 x double> undef, <2 x i32> <i32 1, i32 undef>
; AVX-NEXT:    [[TMP1:%.*]] = fcmp oge <2 x double> [[X:%.*]], [[SHIFT]]
; AVX-NEXT:    [[CMP:%.*]] = extractelement <2 x i1> [[TMP1]], i32 0
; AVX-NEXT:    ret i1 [[CMP]]
;
  %x0 = extractelement <2 x double> %x, i32 0
  %y1 = extractelement <2 x double> %y, i32 1
  %cmp = fcmp oge double %x0, %y1
  ret i1 %cmp
}

define i1 @cmp10_v2f64(<2 x double> %x, <2 x double> %y) {
; SSE-LABEL: @cmp10_v2f64(
; SSE-NEXT:    [[X1:%.*]] = extractelement <2 x double> [[X:%.*]], i32 1
; SSE-NEXT:    [[Y0:%.*]] = extractelement <2 x double> [[Y:%.*]], i32 0
; SSE-NEXT:    [[CMP:%.*]] = fcmp ule double [[X1]], [[Y0]]
; SSE-NEXT:    ret i1 [[CMP]]
;
; AVX-LABEL: @cmp10_v2f64(
; AVX-NEXT:    [[SHIFT:%.*]] = shufflevector <2 x double> [[X:%.*]], <2 x double> undef, <2 x i32> <i32 1, i32 undef>
; AVX-NEXT:    [[TMP1:%.*]] = fcmp ule <2 x double> [[SHIFT]], [[Y:%.*]]
; AVX-NEXT:    [[CMP:%.*]] = extractelement <2 x i1> [[TMP1]], i64 0
; AVX-NEXT:    ret i1 [[CMP]]
;
  %x1 = extractelement <2 x double> %x, i32 1
  %y0 = extractelement <2 x double> %y, i32 0
  %cmp = fcmp ule double %x1, %y0
  ret i1 %cmp
}

define i1 @cmp12_v4i32(<4 x i32> %x, <4 x i32> %y) {
; CHECK-LABEL: @cmp12_v4i32(
; CHECK-NEXT:    [[SHIFT:%.*]] = shufflevector <4 x i32> [[Y:%.*]], <4 x i32> undef, <4 x i32> <i32 undef, i32 2, i32 undef, i32 undef>
; CHECK-NEXT:    [[TMP1:%.*]] = icmp sgt <4 x i32> [[X:%.*]], [[SHIFT]]
; CHECK-NEXT:    [[CMP:%.*]] = extractelement <4 x i1> [[TMP1]], i32 1
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %x1 = extractelement <4 x i32> %x, i32 1
  %y2 = extractelement <4 x i32> %y, i32 2
  %cmp = icmp sgt i32 %x1, %y2
  ret i1 %cmp
}

define <4 x i1> @ins_fcmp_ext_ext(<4 x float> %a, <4 x i1> %b) {
; SSE-LABEL: @ins_fcmp_ext_ext(
; SSE-NEXT:    [[A1:%.*]] = extractelement <4 x float> [[A:%.*]], i32 1
; SSE-NEXT:    [[A2:%.*]] = extractelement <4 x float> [[A]], i32 2
; SSE-NEXT:    [[A21:%.*]] = fcmp ugt float [[A2]], [[A1]]
; SSE-NEXT:    [[R:%.*]] = insertelement <4 x i1> [[B:%.*]], i1 [[A21]], i32 2
; SSE-NEXT:    ret <4 x i1> [[R]]
;
; AVX-LABEL: @ins_fcmp_ext_ext(
; AVX-NEXT:    [[SHIFT:%.*]] = shufflevector <4 x float> [[A:%.*]], <4 x float> undef, <4 x i32> <i32 undef, i32 undef, i32 1, i32 undef>
; AVX-NEXT:    [[TMP1:%.*]] = fcmp ugt <4 x float> [[A]], [[SHIFT]]
; AVX-NEXT:    [[A21:%.*]] = extractelement <4 x i1> [[TMP1]], i32 2
; AVX-NEXT:    [[R:%.*]] = insertelement <4 x i1> [[B:%.*]], i1 [[A21]], i32 2
; AVX-NEXT:    ret <4 x i1> [[R]]
;
  %a1 = extractelement <4 x float> %a, i32 1
  %a2 = extractelement <4 x float> %a, i32 2
  %a21 = fcmp ugt float %a2, %a1
  %r = insertelement <4 x i1> %b, i1 %a21, i32 2
  ret <4 x i1> %r
}

define <4 x i1> @ins_icmp_ext_ext(<4 x i32> %a, <4 x i1> %b) {
; CHECK-LABEL: @ins_icmp_ext_ext(
; CHECK-NEXT:    [[SHIFT:%.*]] = shufflevector <4 x i32> [[A:%.*]], <4 x i32> undef, <4 x i32> <i32 undef, i32 undef, i32 undef, i32 2>
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ule <4 x i32> [[SHIFT]], [[A]]
; CHECK-NEXT:    [[A23:%.*]] = extractelement <4 x i1> [[TMP1]], i64 3
; CHECK-NEXT:    [[R:%.*]] = insertelement <4 x i1> [[B:%.*]], i1 [[A23]], i32 3
; CHECK-NEXT:    ret <4 x i1> [[R]]
;
  %a3 = extractelement <4 x i32> %a, i32 3
  %a2 = extractelement <4 x i32> %a, i32 2
  %a23 = icmp ule i32 %a2, %a3
  %r = insertelement <4 x i1> %b, i1 %a23, i32 3
  ret <4 x i1> %r
}