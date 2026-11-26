; expect: -644880463  -- every floating-point predicate on float operands (zeros of both signs, +-1, +-2.5, +-inf, NaN) as a zext to an integer; the machine has no flags: fcbCC and setless value sequences
; noasm: ^[[:space:]]+(cmp|tst|bit|adc|sbc|set|fcmp|fcmp32|b(ne|eq|pl|mi|vc|vs|cc|cs|ge|lt|gt|le|hi|los|hos|lo)|bhis)[[:space:]]
; asm: ^[[:space:]]+fcb(eq|ne|lt|le|uo|or)[[:space:]]+r[0-9]+\.32,
@sink = global i32 0
@vals = global [9 x float] [float 0x0000000000000000, float 0x8000000000000000, float 0x3FF0000000000000, float 0xBFF0000000000000, float 0x4004000000000000, float 0xC004000000000000, float 0x7FF0000000000000, float 0xFFF0000000000000, float 0x7FF8000000000000]
define i32 @p0(float %a, float %b) noinline {
  %c = fcmp oeq float %a, %b
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @p1(float %a, float %b) noinline {
  %c = fcmp one float %a, %b
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @p2(float %a, float %b) noinline {
  %c = fcmp ogt float %a, %b
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @p3(float %a, float %b) noinline {
  %c = fcmp oge float %a, %b
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @p4(float %a, float %b) noinline {
  %c = fcmp olt float %a, %b
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @p5(float %a, float %b) noinline {
  %c = fcmp ole float %a, %b
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @p6(float %a, float %b) noinline {
  %c = fcmp ueq float %a, %b
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @p7(float %a, float %b) noinline {
  %c = fcmp une float %a, %b
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @p8(float %a, float %b) noinline {
  %c = fcmp ugt float %a, %b
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @p9(float %a, float %b) noinline {
  %c = fcmp uge float %a, %b
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @p10(float %a, float %b) noinline {
  %c = fcmp ult float %a, %b
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @p11(float %a, float %b) noinline {
  %c = fcmp ule float %a, %b
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @p12(float %a, float %b) noinline {
  %c = fcmp ord float %a, %b
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @p13(float %a, float %b) noinline {
  %c = fcmp uno float %a, %b
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @test() {
entry:
  br label %oi
oi:
  %i = phi i64 [0, %entry], [%in, %ol]
  %acc0 = phi i32 [0, %entry], [%accj, %ol]
  br label %il
il:
  %j = phi i64 [0, %oi], [%jn, %il]
  %acc1 = phi i32 [%acc0, %oi], [%accn, %il]
  %pa = getelementptr float, ptr @vals, i64 %i
  %pb = getelementptr float, ptr @vals, i64 %j
  %a = load float, ptr %pa
  %b = load float, ptr %pb
  %r0 = call i32 @p0(float %a, float %b)
  %m0 = mul i32 %acc1, 31
  %h0 = add i32 %m0, %r0
  %r1 = call i32 @p1(float %a, float %b)
  %m1 = mul i32 %h0, 31
  %h1 = add i32 %m1, %r1
  %r2 = call i32 @p2(float %a, float %b)
  %m2 = mul i32 %h1, 31
  %h2 = add i32 %m2, %r2
  %r3 = call i32 @p3(float %a, float %b)
  %m3 = mul i32 %h2, 31
  %h3 = add i32 %m3, %r3
  %r4 = call i32 @p4(float %a, float %b)
  %m4 = mul i32 %h3, 31
  %h4 = add i32 %m4, %r4
  %r5 = call i32 @p5(float %a, float %b)
  %m5 = mul i32 %h4, 31
  %h5 = add i32 %m5, %r5
  %r6 = call i32 @p6(float %a, float %b)
  %m6 = mul i32 %h5, 31
  %h6 = add i32 %m6, %r6
  %r7 = call i32 @p7(float %a, float %b)
  %m7 = mul i32 %h6, 31
  %h7 = add i32 %m7, %r7
  %r8 = call i32 @p8(float %a, float %b)
  %m8 = mul i32 %h7, 31
  %h8 = add i32 %m8, %r8
  %r9 = call i32 @p9(float %a, float %b)
  %m9 = mul i32 %h8, 31
  %h9 = add i32 %m9, %r9
  %r10 = call i32 @p10(float %a, float %b)
  %m10 = mul i32 %h9, 31
  %h10 = add i32 %m10, %r10
  %r11 = call i32 @p11(float %a, float %b)
  %m11 = mul i32 %h10, 31
  %h11 = add i32 %m11, %r11
  %r12 = call i32 @p12(float %a, float %b)
  %m12 = mul i32 %h11, 31
  %h12 = add i32 %m12, %r12
  %r13 = call i32 @p13(float %a, float %b)
  %m13 = mul i32 %h12, 31
  %h13 = add i32 %m13, %r13
  %accn = add i32 %h13, 0
  %jn = add i64 %j, 1
  %jd = icmp eq i64 %jn, 9
  br i1 %jd, label %ol, label %il
ol:
  %accj = add i32 %accn, 0
  %in = add i64 %i, 1
  %id = icmp eq i64 %in, 9
  br i1 %id, label %done, label %oi
done:
  ret i32 %accj
}
