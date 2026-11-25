; expect: 835243961  -- 4-byte maximum and minimum, signed and unsigned, and the wrap of an add
@g = global i32 2147483632
define i32 @test() {
  %acc0 = add i64 0, 0
  %o0 = atomicrmw max ptr @g, i32 -1 seq_cst
  %x0 = sext i32 %o0 to i64
  %m0 = mul i64 %acc0, 31
  %acc1 = add i64 %m0, %x0
  %o1 = atomicrmw umax ptr @g, i32 -1 acq_rel
  %x1 = sext i32 %o1 to i64
  %m1 = mul i64 %acc1, 31
  %acc2 = add i64 %m1, %x1
  %o2 = atomicrmw min ptr @g, i32 5 monotonic
  %x2 = sext i32 %o2 to i64
  %m2 = mul i64 %acc2, 31
  %acc3 = add i64 %m2, %x2
  %o3 = atomicrmw umin ptr @g, i32 5 seq_cst
  %x3 = sext i32 %o3 to i64
  %m3 = mul i64 %acc3, 31
  %acc4 = add i64 %m3, %x3
  %o4 = atomicrmw max ptr @g, i32 2147483647 acquire
  %x4 = sext i32 %o4 to i64
  %m4 = mul i64 %acc4, 31
  %acc5 = add i64 %m4, %x4
  %o5 = atomicrmw add ptr @g, i32 2147483647 release
  %x5 = sext i32 %o5 to i64
  %m5 = mul i64 %acc5, 31
  %acc6 = add i64 %m5, %x5
  %o6 = atomicrmw add ptr @g, i32 2147483647 seq_cst
  %x6 = sext i32 %o6 to i64
  %m6 = mul i64 %acc6, 31
  %acc7 = add i64 %m6, %x6
  %f = load i32, ptr @g
  %fx = sext i32 %f to i64
  %fm = mul i64 %acc7, 31
  %fa = add i64 %fm, %fx
  %r = trunc i64 %fa to i32
  ret i32 %r
}
