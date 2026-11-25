; expect: -1407601228  -- atomic load and store of 1, 2, 4 and 8 bytes are ordinary ones, and a fence is no instruction
@a8 = global i8 0
@a16 = global i16 0
@a32 = global i32 0
@a64 = global i64 0
define i32 @test() {
  store atomic i8 -100, ptr @a8 seq_cst, align 1
  fence seq_cst
  %l0 = load atomic i8, ptr @a8 acquire, align 1
  %x0 = sext i8 %l0 to i64
  store atomic i16 -30000, ptr @a16 seq_cst, align 2
  fence seq_cst
  %l1 = load atomic i16, ptr @a16 acquire, align 2
  %x1 = sext i16 %l1 to i64
  store atomic i32 -2000000000, ptr @a32 seq_cst, align 4
  fence seq_cst
  %l2 = load atomic i32, ptr @a32 acquire, align 4
  %x2 = sext i32 %l2 to i64
  store atomic i64 -9000000000000000000, ptr @a64 seq_cst, align 8
  fence seq_cst
  %l3 = load atomic i64, ptr @a64 acquire, align 8
  %x3 = add i64 %l3, 0
  %m0 = mul i64 0, 31
  %s0 = add i64 %m0, %x0
  %m1 = mul i64 %s0, 31
  %s1 = add i64 %m1, %x1
  %m2 = mul i64 %s1, 31
  %s2 = add i64 %m2, %x2
  %m3 = mul i64 %s2, 31
  %s3 = add i64 %m3, %x3
  %r = trunc i64 %s3 to i32
  ret i32 %r
}
