; expect: -1167353589  -- cmpxchg: the old value, the success flag and the memory after, for 8 and 4 bytes, on success and on failure (the expected value and the old value are one register)
@g8 = global i64 100
@g4 = global i32 -2147483647
define i32 @test() {
  %acc0 = add i64 0, 0
  store i64 100, ptr @g8
  %p0 = cmpxchg ptr @g8, i64 100, i64 200 seq_cst seq_cst
  %v0 = extractvalue { i64, i1 } %p0, 0
  %s0 = extractvalue { i64, i1 } %p0, 1
  %vx0 = add i64 %v0, 0
  %sx0 = zext i1 %s0 to i64
  %l0 = load i64, ptr @g8
  %lx0 = add i64 %l0, 0
  %a0 = mul i64 %acc0, 31
  %b0 = add i64 %a0, %vx0
  %c0 = mul i64 %b0, 31
  %d0 = add i64 %c0, %sx0
  %e0 = mul i64 %d0, 31
  %acc1 = add i64 %e0, %lx0
  store i64 100, ptr @g8
  %p1 = cmpxchg ptr @g8, i64 150, i64 300 seq_cst seq_cst
  %v1 = extractvalue { i64, i1 } %p1, 0
  %s1 = extractvalue { i64, i1 } %p1, 1
  %vx1 = add i64 %v1, 0
  %sx1 = zext i1 %s1 to i64
  %l1 = load i64, ptr @g8
  %lx1 = add i64 %l1, 0
  %a1 = mul i64 %acc1, 31
  %b1 = add i64 %a1, %vx1
  %c1 = mul i64 %b1, 31
  %d1 = add i64 %c1, %sx1
  %e1 = mul i64 %d1, 31
  %acc2 = add i64 %e1, %lx1
  store i32 -2147483647, ptr @g4
  %p2 = cmpxchg ptr @g4, i32 -2147483647, i32 7 acq_rel acquire
  %v2 = extractvalue { i32, i1 } %p2, 0
  %s2 = extractvalue { i32, i1 } %p2, 1
  %vx2 = sext i32 %v2 to i64
  %sx2 = zext i1 %s2 to i64
  %l2 = load i32, ptr @g4
  %lx2 = sext i32 %l2 to i64
  %a2 = mul i64 %acc2, 31
  %b2 = add i64 %a2, %vx2
  %c2 = mul i64 %b2, 31
  %d2 = add i64 %c2, %sx2
  %e2 = mul i64 %d2, 31
  %acc3 = add i64 %e2, %lx2
  store i32 7, ptr @g4
  %p3 = cmpxchg ptr @g4, i32 -1, i32 9 monotonic monotonic
  %v3 = extractvalue { i32, i1 } %p3, 0
  %s3 = extractvalue { i32, i1 } %p3, 1
  %vx3 = sext i32 %v3 to i64
  %sx3 = zext i1 %s3 to i64
  %l3 = load i32, ptr @g4
  %lx3 = sext i32 %l3 to i64
  %a3 = mul i64 %acc3, 31
  %b3 = add i64 %a3, %vx3
  %c3 = mul i64 %b3, 31
  %d3 = add i64 %c3, %sx3
  %e3 = mul i64 %d3, 31
  %acc4 = add i64 %e3, %lx3
  store i32 7, ptr @g4
  %p4 = cmpxchg ptr @g4, i32 7, i32 9 seq_cst monotonic
  %v4 = extractvalue { i32, i1 } %p4, 0
  %s4 = extractvalue { i32, i1 } %p4, 1
  %vx4 = sext i32 %v4 to i64
  %sx4 = zext i1 %s4 to i64
  %l4 = load i32, ptr @g4
  %lx4 = sext i32 %l4 to i64
  %a4 = mul i64 %acc4, 31
  %b4 = add i64 %a4, %vx4
  %c4 = mul i64 %b4, 31
  %d4 = add i64 %c4, %sx4
  %e4 = mul i64 %d4, 31
  %acc5 = add i64 %e4, %lx4
  %r = trunc i64 %acc5 to i32
  ret i32 %r
}
