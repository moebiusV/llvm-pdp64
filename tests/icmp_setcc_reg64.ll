; expect: 2136722792  -- every integer condition on i64 against a register as a value (setCC); operands around the edges of the immediate fields
; noasm: ^[[:space:]]+(cmp|tst|bit|adc|sbc|set|fcmp|fcmp32|b(ne|eq|pl|mi|vc|vs|cc|cs|ge|lt|gt|le|hi|los|hos|lo)|bhis)[[:space:]]
; asm: ^[[:space:]]+set(eq|ne|lt|le|gt|ge|cs|cc|hi|los)[[:space:]]
@sink = global i32 0
@av = global [44 x i64] [i64 -9223372036854775808, i64 -9223372036854775807, i64 -2147483649, i64 -2147483648, i64 -65536, i64 -32770, i64 -32769, i64 -32768, i64 -32767, i64 -2050, i64 -2049, i64 -2048, i64 -2047, i64 -130, i64 -129, i64 -128, i64 -127, i64 -126, i64 -2, i64 -1, i64 0, i64 1, i64 2, i64 126, i64 127, i64 128, i64 129, i64 2046, i64 2047, i64 2048, i64 2049, i64 32766, i64 32767, i64 32768, i64 32769, i64 65535, i64 65536, i64 2147483647, i64 2147483648, i64 4294967295, i64 4294967296, i64 1099511627776, i64 9223372036854775806, i64 9223372036854775807]
define i32 @f0(i64 %a, i64 %b) noinline {
  %c = icmp eq i64 %a, %b
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f1(i64 %a, i64 %b) noinline {
  %c = icmp ne i64 %a, %b
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f2(i64 %a, i64 %b) noinline {
  %c = icmp slt i64 %a, %b
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f3(i64 %a, i64 %b) noinline {
  %c = icmp sle i64 %a, %b
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f4(i64 %a, i64 %b) noinline {
  %c = icmp sgt i64 %a, %b
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f5(i64 %a, i64 %b) noinline {
  %c = icmp sge i64 %a, %b
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f6(i64 %a, i64 %b) noinline {
  %c = icmp ult i64 %a, %b
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f7(i64 %a, i64 %b) noinline {
  %c = icmp ule i64 %a, %b
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f8(i64 %a, i64 %b) noinline {
  %c = icmp ugt i64 %a, %b
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f9(i64 %a, i64 %b) noinline {
  %c = icmp uge i64 %a, %b
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
  %pb = getelementptr i64, ptr @av, i64 %j
  %b64 = load i64, ptr %pb
  %pa = getelementptr i64, ptr @av, i64 %i
  %a64 = load i64, ptr %pa
  %a = add i64 %a64, 0
  %b = add i64 %b64, 0
  %r0 = call i32 @f0(i64 %a, i64 %b)
  %m0 = mul i32 %acc1, 31
  %h0 = add i32 %m0, %r0
  %r1 = call i32 @f1(i64 %a, i64 %b)
  %m1 = mul i32 %h0, 31
  %h1 = add i32 %m1, %r1
  %r2 = call i32 @f2(i64 %a, i64 %b)
  %m2 = mul i32 %h1, 31
  %h2 = add i32 %m2, %r2
  %r3 = call i32 @f3(i64 %a, i64 %b)
  %m3 = mul i32 %h2, 31
  %h3 = add i32 %m3, %r3
  %r4 = call i32 @f4(i64 %a, i64 %b)
  %m4 = mul i32 %h3, 31
  %h4 = add i32 %m4, %r4
  %r5 = call i32 @f5(i64 %a, i64 %b)
  %m5 = mul i32 %h4, 31
  %h5 = add i32 %m5, %r5
  %r6 = call i32 @f6(i64 %a, i64 %b)
  %m6 = mul i32 %h5, 31
  %h6 = add i32 %m6, %r6
  %r7 = call i32 @f7(i64 %a, i64 %b)
  %m7 = mul i32 %h6, 31
  %h7 = add i32 %m7, %r7
  %r8 = call i32 @f8(i64 %a, i64 %b)
  %m8 = mul i32 %h7, 31
  %h8 = add i32 %m8, %r8
  %r9 = call i32 @f9(i64 %a, i64 %b)
  %m9 = mul i32 %h8, 31
  %h9 = add i32 %m9, %r9
  %accn = add i32 %h9, 0
  %jn = add i64 %j, 1
  %jd = icmp eq i64 %jn, 44
  br i1 %jd, label %ol, label %il
ol:
  %accj = add i32 %accn, 0
  %in = add i64 %i, 1
  %id = icmp eq i64 %in, 44
  br i1 %id, label %done, label %oi
done:
  ret i32 %accj
}
