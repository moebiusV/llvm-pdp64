; expect: -790429932  -- a packed struct: fields of 32, 64 and 16 bits at odd offsets are plain loads and stores, one instruction each (no byte accesses: a plain access works at any address)
; noasm: mov.s8
%P = type <{ i8, i32, i64, i16 }>
@g = global %P <{ i8 1, i32 16909060, i64 1234605616436508552, i16 2571 }>, align 1
define i32 @test() {
  %p1 = getelementptr %P, ptr @g, i32 0, i32 1
  %p2 = getelementptr %P, ptr @g, i32 0, i32 2
  %p3 = getelementptr %P, ptr @g, i32 0, i32 3
  %a = load i32, ptr %p1, align 1
  %b = load i64, ptr %p2, align 1
  %c = load i16, ptr %p3, align 1
  store i32 2054847101, ptr %p1, align 1
  %a2 = load i32, ptr %p1, align 1
  %a64 = zext i32 %a to i64
  %c64 = zext i16 %c to i64
  %a264 = zext i32 %a2 to i64
  %s1 = add i64 %a64, %b
  %s2 = add i64 %s1, %c64
  %s3 = add i64 %s2, %a264
  %t = trunc i64 %s3 to i32
  ret i32 %t
}
