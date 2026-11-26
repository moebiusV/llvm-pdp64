; expect: -837133824  -- every integer condition on i64 against constants as a value (setCC); operands around the edges of the immediate fields
; noasm: ^[[:space:]]+(cmp|tst|bit|adc|sbc|set|fcmp|fcmp32|b(ne|eq|pl|mi|vc|vs|cc|cs|ge|lt|gt|le|hi|los|hos|lo)|bhis)[[:space:]]
; asm: ^[[:space:]]+set(eq|ne|lt|le|gt|ge|cs|cc|hi|los)[[:space:]]
@sink = global i32 0
@av = global [44 x i64] [i64 -9223372036854775808, i64 -9223372036854775807, i64 -2147483649, i64 -2147483648, i64 -65536, i64 -32770, i64 -32769, i64 -32768, i64 -32767, i64 -2050, i64 -2049, i64 -2048, i64 -2047, i64 -130, i64 -129, i64 -128, i64 -127, i64 -126, i64 -2, i64 -1, i64 0, i64 1, i64 2, i64 126, i64 127, i64 128, i64 129, i64 2046, i64 2047, i64 2048, i64 2049, i64 32766, i64 32767, i64 32768, i64 32769, i64 65535, i64 65536, i64 2147483647, i64 2147483648, i64 4294967295, i64 4294967296, i64 1099511627776, i64 9223372036854775806, i64 9223372036854775807]
define i32 @f0(i64 %a) noinline {
  %c = icmp eq i64 %a, -32769
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f1(i64 %a) noinline {
  %c = icmp eq i64 %a, -32768
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f2(i64 %a) noinline {
  %c = icmp eq i64 %a, -2049
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f3(i64 %a) noinline {
  %c = icmp eq i64 %a, -2048
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f4(i64 %a) noinline {
  %c = icmp eq i64 %a, -129
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f5(i64 %a) noinline {
  %c = icmp eq i64 %a, -128
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f6(i64 %a) noinline {
  %c = icmp eq i64 %a, -127
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f7(i64 %a) noinline {
  %c = icmp eq i64 %a, -1
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f8(i64 %a) noinline {
  %c = icmp eq i64 %a, 0
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f9(i64 %a) noinline {
  %c = icmp eq i64 %a, 1
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f10(i64 %a) noinline {
  %c = icmp eq i64 %a, 126
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f11(i64 %a) noinline {
  %c = icmp eq i64 %a, 127
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f12(i64 %a) noinline {
  %c = icmp eq i64 %a, 128
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f13(i64 %a) noinline {
  %c = icmp eq i64 %a, 129
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f14(i64 %a) noinline {
  %c = icmp eq i64 %a, 2047
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f15(i64 %a) noinline {
  %c = icmp eq i64 %a, 2048
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f16(i64 %a) noinline {
  %c = icmp eq i64 %a, 32767
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f17(i64 %a) noinline {
  %c = icmp eq i64 %a, 32768
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f18(i64 %a) noinline {
  %c = icmp eq i64 %a, 65535
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f19(i64 %a) noinline {
  %c = icmp eq i64 %a, 2147483647
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f20(i64 %a) noinline {
  %c = icmp eq i64 %a, -2147483648
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f21(i64 %a) noinline {
  %c = icmp eq i64 %a, 1099511627776
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f22(i64 %a) noinline {
  %c = icmp eq i64 %a, -9223372036854775808
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f23(i64 %a) noinline {
  %c = icmp eq i64 %a, 9223372036854775807
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f24(i64 %a) noinline {
  %c = icmp ne i64 %a, -32769
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f25(i64 %a) noinline {
  %c = icmp ne i64 %a, -32768
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f26(i64 %a) noinline {
  %c = icmp ne i64 %a, -2049
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f27(i64 %a) noinline {
  %c = icmp ne i64 %a, -2048
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f28(i64 %a) noinline {
  %c = icmp ne i64 %a, -129
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f29(i64 %a) noinline {
  %c = icmp ne i64 %a, -128
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f30(i64 %a) noinline {
  %c = icmp ne i64 %a, -127
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f31(i64 %a) noinline {
  %c = icmp ne i64 %a, -1
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f32(i64 %a) noinline {
  %c = icmp ne i64 %a, 0
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f33(i64 %a) noinline {
  %c = icmp ne i64 %a, 1
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f34(i64 %a) noinline {
  %c = icmp ne i64 %a, 126
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f35(i64 %a) noinline {
  %c = icmp ne i64 %a, 127
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f36(i64 %a) noinline {
  %c = icmp ne i64 %a, 128
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f37(i64 %a) noinline {
  %c = icmp ne i64 %a, 129
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f38(i64 %a) noinline {
  %c = icmp ne i64 %a, 2047
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f39(i64 %a) noinline {
  %c = icmp ne i64 %a, 2048
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f40(i64 %a) noinline {
  %c = icmp ne i64 %a, 32767
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f41(i64 %a) noinline {
  %c = icmp ne i64 %a, 32768
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f42(i64 %a) noinline {
  %c = icmp ne i64 %a, 65535
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f43(i64 %a) noinline {
  %c = icmp ne i64 %a, 2147483647
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f44(i64 %a) noinline {
  %c = icmp ne i64 %a, -2147483648
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f45(i64 %a) noinline {
  %c = icmp ne i64 %a, 1099511627776
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f46(i64 %a) noinline {
  %c = icmp ne i64 %a, -9223372036854775808
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f47(i64 %a) noinline {
  %c = icmp ne i64 %a, 9223372036854775807
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f48(i64 %a) noinline {
  %c = icmp slt i64 %a, -32769
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f49(i64 %a) noinline {
  %c = icmp slt i64 %a, -32768
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f50(i64 %a) noinline {
  %c = icmp slt i64 %a, -2049
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f51(i64 %a) noinline {
  %c = icmp slt i64 %a, -2048
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f52(i64 %a) noinline {
  %c = icmp slt i64 %a, -129
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f53(i64 %a) noinline {
  %c = icmp slt i64 %a, -128
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f54(i64 %a) noinline {
  %c = icmp slt i64 %a, -127
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f55(i64 %a) noinline {
  %c = icmp slt i64 %a, -1
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f56(i64 %a) noinline {
  %c = icmp slt i64 %a, 0
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f57(i64 %a) noinline {
  %c = icmp slt i64 %a, 1
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f58(i64 %a) noinline {
  %c = icmp slt i64 %a, 126
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f59(i64 %a) noinline {
  %c = icmp slt i64 %a, 127
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f60(i64 %a) noinline {
  %c = icmp slt i64 %a, 128
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f61(i64 %a) noinline {
  %c = icmp slt i64 %a, 129
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f62(i64 %a) noinline {
  %c = icmp slt i64 %a, 2047
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f63(i64 %a) noinline {
  %c = icmp slt i64 %a, 2048
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f64(i64 %a) noinline {
  %c = icmp slt i64 %a, 32767
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f65(i64 %a) noinline {
  %c = icmp slt i64 %a, 32768
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f66(i64 %a) noinline {
  %c = icmp slt i64 %a, 65535
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f67(i64 %a) noinline {
  %c = icmp slt i64 %a, 2147483647
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f68(i64 %a) noinline {
  %c = icmp slt i64 %a, -2147483648
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f69(i64 %a) noinline {
  %c = icmp slt i64 %a, 1099511627776
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f70(i64 %a) noinline {
  %c = icmp slt i64 %a, -9223372036854775808
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f71(i64 %a) noinline {
  %c = icmp slt i64 %a, 9223372036854775807
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f72(i64 %a) noinline {
  %c = icmp sle i64 %a, -32769
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f73(i64 %a) noinline {
  %c = icmp sle i64 %a, -32768
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f74(i64 %a) noinline {
  %c = icmp sle i64 %a, -2049
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f75(i64 %a) noinline {
  %c = icmp sle i64 %a, -2048
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f76(i64 %a) noinline {
  %c = icmp sle i64 %a, -129
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f77(i64 %a) noinline {
  %c = icmp sle i64 %a, -128
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f78(i64 %a) noinline {
  %c = icmp sle i64 %a, -127
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f79(i64 %a) noinline {
  %c = icmp sle i64 %a, -1
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f80(i64 %a) noinline {
  %c = icmp sle i64 %a, 0
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f81(i64 %a) noinline {
  %c = icmp sle i64 %a, 1
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f82(i64 %a) noinline {
  %c = icmp sle i64 %a, 126
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f83(i64 %a) noinline {
  %c = icmp sle i64 %a, 127
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f84(i64 %a) noinline {
  %c = icmp sle i64 %a, 128
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f85(i64 %a) noinline {
  %c = icmp sle i64 %a, 129
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f86(i64 %a) noinline {
  %c = icmp sle i64 %a, 2047
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f87(i64 %a) noinline {
  %c = icmp sle i64 %a, 2048
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f88(i64 %a) noinline {
  %c = icmp sle i64 %a, 32767
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f89(i64 %a) noinline {
  %c = icmp sle i64 %a, 32768
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f90(i64 %a) noinline {
  %c = icmp sle i64 %a, 65535
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f91(i64 %a) noinline {
  %c = icmp sle i64 %a, 2147483647
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f92(i64 %a) noinline {
  %c = icmp sle i64 %a, -2147483648
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f93(i64 %a) noinline {
  %c = icmp sle i64 %a, 1099511627776
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f94(i64 %a) noinline {
  %c = icmp sle i64 %a, -9223372036854775808
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f95(i64 %a) noinline {
  %c = icmp sle i64 %a, 9223372036854775807
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f96(i64 %a) noinline {
  %c = icmp sgt i64 %a, -32769
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f97(i64 %a) noinline {
  %c = icmp sgt i64 %a, -32768
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f98(i64 %a) noinline {
  %c = icmp sgt i64 %a, -2049
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f99(i64 %a) noinline {
  %c = icmp sgt i64 %a, -2048
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f100(i64 %a) noinline {
  %c = icmp sgt i64 %a, -129
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f101(i64 %a) noinline {
  %c = icmp sgt i64 %a, -128
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f102(i64 %a) noinline {
  %c = icmp sgt i64 %a, -127
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f103(i64 %a) noinline {
  %c = icmp sgt i64 %a, -1
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f104(i64 %a) noinline {
  %c = icmp sgt i64 %a, 0
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f105(i64 %a) noinline {
  %c = icmp sgt i64 %a, 1
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f106(i64 %a) noinline {
  %c = icmp sgt i64 %a, 126
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f107(i64 %a) noinline {
  %c = icmp sgt i64 %a, 127
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f108(i64 %a) noinline {
  %c = icmp sgt i64 %a, 128
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f109(i64 %a) noinline {
  %c = icmp sgt i64 %a, 129
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f110(i64 %a) noinline {
  %c = icmp sgt i64 %a, 2047
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f111(i64 %a) noinline {
  %c = icmp sgt i64 %a, 2048
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f112(i64 %a) noinline {
  %c = icmp sgt i64 %a, 32767
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f113(i64 %a) noinline {
  %c = icmp sgt i64 %a, 32768
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f114(i64 %a) noinline {
  %c = icmp sgt i64 %a, 65535
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f115(i64 %a) noinline {
  %c = icmp sgt i64 %a, 2147483647
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f116(i64 %a) noinline {
  %c = icmp sgt i64 %a, -2147483648
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f117(i64 %a) noinline {
  %c = icmp sgt i64 %a, 1099511627776
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f118(i64 %a) noinline {
  %c = icmp sgt i64 %a, -9223372036854775808
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f119(i64 %a) noinline {
  %c = icmp sgt i64 %a, 9223372036854775807
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f120(i64 %a) noinline {
  %c = icmp sge i64 %a, -32769
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f121(i64 %a) noinline {
  %c = icmp sge i64 %a, -32768
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f122(i64 %a) noinline {
  %c = icmp sge i64 %a, -2049
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f123(i64 %a) noinline {
  %c = icmp sge i64 %a, -2048
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f124(i64 %a) noinline {
  %c = icmp sge i64 %a, -129
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f125(i64 %a) noinline {
  %c = icmp sge i64 %a, -128
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f126(i64 %a) noinline {
  %c = icmp sge i64 %a, -127
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f127(i64 %a) noinline {
  %c = icmp sge i64 %a, -1
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f128(i64 %a) noinline {
  %c = icmp sge i64 %a, 0
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f129(i64 %a) noinline {
  %c = icmp sge i64 %a, 1
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f130(i64 %a) noinline {
  %c = icmp sge i64 %a, 126
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f131(i64 %a) noinline {
  %c = icmp sge i64 %a, 127
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f132(i64 %a) noinline {
  %c = icmp sge i64 %a, 128
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f133(i64 %a) noinline {
  %c = icmp sge i64 %a, 129
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f134(i64 %a) noinline {
  %c = icmp sge i64 %a, 2047
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f135(i64 %a) noinline {
  %c = icmp sge i64 %a, 2048
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f136(i64 %a) noinline {
  %c = icmp sge i64 %a, 32767
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f137(i64 %a) noinline {
  %c = icmp sge i64 %a, 32768
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f138(i64 %a) noinline {
  %c = icmp sge i64 %a, 65535
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f139(i64 %a) noinline {
  %c = icmp sge i64 %a, 2147483647
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f140(i64 %a) noinline {
  %c = icmp sge i64 %a, -2147483648
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f141(i64 %a) noinline {
  %c = icmp sge i64 %a, 1099511627776
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f142(i64 %a) noinline {
  %c = icmp sge i64 %a, -9223372036854775808
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f143(i64 %a) noinline {
  %c = icmp sge i64 %a, 9223372036854775807
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f144(i64 %a) noinline {
  %c = icmp ult i64 %a, -32769
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f145(i64 %a) noinline {
  %c = icmp ult i64 %a, -32768
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f146(i64 %a) noinline {
  %c = icmp ult i64 %a, -2049
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f147(i64 %a) noinline {
  %c = icmp ult i64 %a, -2048
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f148(i64 %a) noinline {
  %c = icmp ult i64 %a, -129
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f149(i64 %a) noinline {
  %c = icmp ult i64 %a, -128
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f150(i64 %a) noinline {
  %c = icmp ult i64 %a, -127
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f151(i64 %a) noinline {
  %c = icmp ult i64 %a, -1
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f152(i64 %a) noinline {
  %c = icmp ult i64 %a, 0
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f153(i64 %a) noinline {
  %c = icmp ult i64 %a, 1
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f154(i64 %a) noinline {
  %c = icmp ult i64 %a, 126
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f155(i64 %a) noinline {
  %c = icmp ult i64 %a, 127
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f156(i64 %a) noinline {
  %c = icmp ult i64 %a, 128
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f157(i64 %a) noinline {
  %c = icmp ult i64 %a, 129
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f158(i64 %a) noinline {
  %c = icmp ult i64 %a, 2047
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f159(i64 %a) noinline {
  %c = icmp ult i64 %a, 2048
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f160(i64 %a) noinline {
  %c = icmp ult i64 %a, 32767
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f161(i64 %a) noinline {
  %c = icmp ult i64 %a, 32768
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f162(i64 %a) noinline {
  %c = icmp ult i64 %a, 65535
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f163(i64 %a) noinline {
  %c = icmp ult i64 %a, 2147483647
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f164(i64 %a) noinline {
  %c = icmp ult i64 %a, -2147483648
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f165(i64 %a) noinline {
  %c = icmp ult i64 %a, 1099511627776
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f166(i64 %a) noinline {
  %c = icmp ult i64 %a, -9223372036854775808
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f167(i64 %a) noinline {
  %c = icmp ult i64 %a, 9223372036854775807
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f168(i64 %a) noinline {
  %c = icmp ule i64 %a, -32769
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f169(i64 %a) noinline {
  %c = icmp ule i64 %a, -32768
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f170(i64 %a) noinline {
  %c = icmp ule i64 %a, -2049
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f171(i64 %a) noinline {
  %c = icmp ule i64 %a, -2048
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f172(i64 %a) noinline {
  %c = icmp ule i64 %a, -129
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f173(i64 %a) noinline {
  %c = icmp ule i64 %a, -128
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f174(i64 %a) noinline {
  %c = icmp ule i64 %a, -127
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f175(i64 %a) noinline {
  %c = icmp ule i64 %a, -1
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f176(i64 %a) noinline {
  %c = icmp ule i64 %a, 0
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f177(i64 %a) noinline {
  %c = icmp ule i64 %a, 1
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f178(i64 %a) noinline {
  %c = icmp ule i64 %a, 126
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f179(i64 %a) noinline {
  %c = icmp ule i64 %a, 127
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f180(i64 %a) noinline {
  %c = icmp ule i64 %a, 128
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f181(i64 %a) noinline {
  %c = icmp ule i64 %a, 129
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f182(i64 %a) noinline {
  %c = icmp ule i64 %a, 2047
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f183(i64 %a) noinline {
  %c = icmp ule i64 %a, 2048
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f184(i64 %a) noinline {
  %c = icmp ule i64 %a, 32767
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f185(i64 %a) noinline {
  %c = icmp ule i64 %a, 32768
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f186(i64 %a) noinline {
  %c = icmp ule i64 %a, 65535
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f187(i64 %a) noinline {
  %c = icmp ule i64 %a, 2147483647
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f188(i64 %a) noinline {
  %c = icmp ule i64 %a, -2147483648
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f189(i64 %a) noinline {
  %c = icmp ule i64 %a, 1099511627776
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f190(i64 %a) noinline {
  %c = icmp ule i64 %a, -9223372036854775808
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f191(i64 %a) noinline {
  %c = icmp ule i64 %a, 9223372036854775807
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f192(i64 %a) noinline {
  %c = icmp ugt i64 %a, -32769
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f193(i64 %a) noinline {
  %c = icmp ugt i64 %a, -32768
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f194(i64 %a) noinline {
  %c = icmp ugt i64 %a, -2049
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f195(i64 %a) noinline {
  %c = icmp ugt i64 %a, -2048
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f196(i64 %a) noinline {
  %c = icmp ugt i64 %a, -129
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f197(i64 %a) noinline {
  %c = icmp ugt i64 %a, -128
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f198(i64 %a) noinline {
  %c = icmp ugt i64 %a, -127
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f199(i64 %a) noinline {
  %c = icmp ugt i64 %a, -1
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f200(i64 %a) noinline {
  %c = icmp ugt i64 %a, 0
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f201(i64 %a) noinline {
  %c = icmp ugt i64 %a, 1
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f202(i64 %a) noinline {
  %c = icmp ugt i64 %a, 126
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f203(i64 %a) noinline {
  %c = icmp ugt i64 %a, 127
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f204(i64 %a) noinline {
  %c = icmp ugt i64 %a, 128
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f205(i64 %a) noinline {
  %c = icmp ugt i64 %a, 129
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f206(i64 %a) noinline {
  %c = icmp ugt i64 %a, 2047
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f207(i64 %a) noinline {
  %c = icmp ugt i64 %a, 2048
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f208(i64 %a) noinline {
  %c = icmp ugt i64 %a, 32767
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f209(i64 %a) noinline {
  %c = icmp ugt i64 %a, 32768
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f210(i64 %a) noinline {
  %c = icmp ugt i64 %a, 65535
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f211(i64 %a) noinline {
  %c = icmp ugt i64 %a, 2147483647
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f212(i64 %a) noinline {
  %c = icmp ugt i64 %a, -2147483648
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f213(i64 %a) noinline {
  %c = icmp ugt i64 %a, 1099511627776
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f214(i64 %a) noinline {
  %c = icmp ugt i64 %a, -9223372036854775808
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f215(i64 %a) noinline {
  %c = icmp ugt i64 %a, 9223372036854775807
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f216(i64 %a) noinline {
  %c = icmp uge i64 %a, -32769
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f217(i64 %a) noinline {
  %c = icmp uge i64 %a, -32768
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f218(i64 %a) noinline {
  %c = icmp uge i64 %a, -2049
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f219(i64 %a) noinline {
  %c = icmp uge i64 %a, -2048
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f220(i64 %a) noinline {
  %c = icmp uge i64 %a, -129
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f221(i64 %a) noinline {
  %c = icmp uge i64 %a, -128
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f222(i64 %a) noinline {
  %c = icmp uge i64 %a, -127
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f223(i64 %a) noinline {
  %c = icmp uge i64 %a, -1
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f224(i64 %a) noinline {
  %c = icmp uge i64 %a, 0
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f225(i64 %a) noinline {
  %c = icmp uge i64 %a, 1
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f226(i64 %a) noinline {
  %c = icmp uge i64 %a, 126
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f227(i64 %a) noinline {
  %c = icmp uge i64 %a, 127
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f228(i64 %a) noinline {
  %c = icmp uge i64 %a, 128
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f229(i64 %a) noinline {
  %c = icmp uge i64 %a, 129
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f230(i64 %a) noinline {
  %c = icmp uge i64 %a, 2047
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f231(i64 %a) noinline {
  %c = icmp uge i64 %a, 2048
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f232(i64 %a) noinline {
  %c = icmp uge i64 %a, 32767
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f233(i64 %a) noinline {
  %c = icmp uge i64 %a, 32768
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f234(i64 %a) noinline {
  %c = icmp uge i64 %a, 65535
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f235(i64 %a) noinline {
  %c = icmp uge i64 %a, 2147483647
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f236(i64 %a) noinline {
  %c = icmp uge i64 %a, -2147483648
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f237(i64 %a) noinline {
  %c = icmp uge i64 %a, 1099511627776
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f238(i64 %a) noinline {
  %c = icmp uge i64 %a, -9223372036854775808
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @f239(i64 %a) noinline {
  %c = icmp uge i64 %a, 9223372036854775807
  %r = zext i1 %c to i32
  ret i32 %r
}
define i32 @test() {
entry:
  br label %oi
oi:
  %i = phi i64 [0, %entry], [%in, %ol]
  %acc0 = phi i32 [0, %entry], [%accj, %ol]
  %pa = getelementptr i64, ptr @av, i64 %i
  %a64 = load i64, ptr %pa
  %a = add i64 %a64, 0
  %r0 = call i32 @f0(i64 %a)
  %m0 = mul i32 %acc0, 31
  %h0 = add i32 %m0, %r0
  %r1 = call i32 @f1(i64 %a)
  %m1 = mul i32 %h0, 31
  %h1 = add i32 %m1, %r1
  %r2 = call i32 @f2(i64 %a)
  %m2 = mul i32 %h1, 31
  %h2 = add i32 %m2, %r2
  %r3 = call i32 @f3(i64 %a)
  %m3 = mul i32 %h2, 31
  %h3 = add i32 %m3, %r3
  %r4 = call i32 @f4(i64 %a)
  %m4 = mul i32 %h3, 31
  %h4 = add i32 %m4, %r4
  %r5 = call i32 @f5(i64 %a)
  %m5 = mul i32 %h4, 31
  %h5 = add i32 %m5, %r5
  %r6 = call i32 @f6(i64 %a)
  %m6 = mul i32 %h5, 31
  %h6 = add i32 %m6, %r6
  %r7 = call i32 @f7(i64 %a)
  %m7 = mul i32 %h6, 31
  %h7 = add i32 %m7, %r7
  %r8 = call i32 @f8(i64 %a)
  %m8 = mul i32 %h7, 31
  %h8 = add i32 %m8, %r8
  %r9 = call i32 @f9(i64 %a)
  %m9 = mul i32 %h8, 31
  %h9 = add i32 %m9, %r9
  %r10 = call i32 @f10(i64 %a)
  %m10 = mul i32 %h9, 31
  %h10 = add i32 %m10, %r10
  %r11 = call i32 @f11(i64 %a)
  %m11 = mul i32 %h10, 31
  %h11 = add i32 %m11, %r11
  %r12 = call i32 @f12(i64 %a)
  %m12 = mul i32 %h11, 31
  %h12 = add i32 %m12, %r12
  %r13 = call i32 @f13(i64 %a)
  %m13 = mul i32 %h12, 31
  %h13 = add i32 %m13, %r13
  %r14 = call i32 @f14(i64 %a)
  %m14 = mul i32 %h13, 31
  %h14 = add i32 %m14, %r14
  %r15 = call i32 @f15(i64 %a)
  %m15 = mul i32 %h14, 31
  %h15 = add i32 %m15, %r15
  %r16 = call i32 @f16(i64 %a)
  %m16 = mul i32 %h15, 31
  %h16 = add i32 %m16, %r16
  %r17 = call i32 @f17(i64 %a)
  %m17 = mul i32 %h16, 31
  %h17 = add i32 %m17, %r17
  %r18 = call i32 @f18(i64 %a)
  %m18 = mul i32 %h17, 31
  %h18 = add i32 %m18, %r18
  %r19 = call i32 @f19(i64 %a)
  %m19 = mul i32 %h18, 31
  %h19 = add i32 %m19, %r19
  %r20 = call i32 @f20(i64 %a)
  %m20 = mul i32 %h19, 31
  %h20 = add i32 %m20, %r20
  %r21 = call i32 @f21(i64 %a)
  %m21 = mul i32 %h20, 31
  %h21 = add i32 %m21, %r21
  %r22 = call i32 @f22(i64 %a)
  %m22 = mul i32 %h21, 31
  %h22 = add i32 %m22, %r22
  %r23 = call i32 @f23(i64 %a)
  %m23 = mul i32 %h22, 31
  %h23 = add i32 %m23, %r23
  %r24 = call i32 @f24(i64 %a)
  %m24 = mul i32 %h23, 31
  %h24 = add i32 %m24, %r24
  %r25 = call i32 @f25(i64 %a)
  %m25 = mul i32 %h24, 31
  %h25 = add i32 %m25, %r25
  %r26 = call i32 @f26(i64 %a)
  %m26 = mul i32 %h25, 31
  %h26 = add i32 %m26, %r26
  %r27 = call i32 @f27(i64 %a)
  %m27 = mul i32 %h26, 31
  %h27 = add i32 %m27, %r27
  %r28 = call i32 @f28(i64 %a)
  %m28 = mul i32 %h27, 31
  %h28 = add i32 %m28, %r28
  %r29 = call i32 @f29(i64 %a)
  %m29 = mul i32 %h28, 31
  %h29 = add i32 %m29, %r29
  %r30 = call i32 @f30(i64 %a)
  %m30 = mul i32 %h29, 31
  %h30 = add i32 %m30, %r30
  %r31 = call i32 @f31(i64 %a)
  %m31 = mul i32 %h30, 31
  %h31 = add i32 %m31, %r31
  %r32 = call i32 @f32(i64 %a)
  %m32 = mul i32 %h31, 31
  %h32 = add i32 %m32, %r32
  %r33 = call i32 @f33(i64 %a)
  %m33 = mul i32 %h32, 31
  %h33 = add i32 %m33, %r33
  %r34 = call i32 @f34(i64 %a)
  %m34 = mul i32 %h33, 31
  %h34 = add i32 %m34, %r34
  %r35 = call i32 @f35(i64 %a)
  %m35 = mul i32 %h34, 31
  %h35 = add i32 %m35, %r35
  %r36 = call i32 @f36(i64 %a)
  %m36 = mul i32 %h35, 31
  %h36 = add i32 %m36, %r36
  %r37 = call i32 @f37(i64 %a)
  %m37 = mul i32 %h36, 31
  %h37 = add i32 %m37, %r37
  %r38 = call i32 @f38(i64 %a)
  %m38 = mul i32 %h37, 31
  %h38 = add i32 %m38, %r38
  %r39 = call i32 @f39(i64 %a)
  %m39 = mul i32 %h38, 31
  %h39 = add i32 %m39, %r39
  %r40 = call i32 @f40(i64 %a)
  %m40 = mul i32 %h39, 31
  %h40 = add i32 %m40, %r40
  %r41 = call i32 @f41(i64 %a)
  %m41 = mul i32 %h40, 31
  %h41 = add i32 %m41, %r41
  %r42 = call i32 @f42(i64 %a)
  %m42 = mul i32 %h41, 31
  %h42 = add i32 %m42, %r42
  %r43 = call i32 @f43(i64 %a)
  %m43 = mul i32 %h42, 31
  %h43 = add i32 %m43, %r43
  %r44 = call i32 @f44(i64 %a)
  %m44 = mul i32 %h43, 31
  %h44 = add i32 %m44, %r44
  %r45 = call i32 @f45(i64 %a)
  %m45 = mul i32 %h44, 31
  %h45 = add i32 %m45, %r45
  %r46 = call i32 @f46(i64 %a)
  %m46 = mul i32 %h45, 31
  %h46 = add i32 %m46, %r46
  %r47 = call i32 @f47(i64 %a)
  %m47 = mul i32 %h46, 31
  %h47 = add i32 %m47, %r47
  %r48 = call i32 @f48(i64 %a)
  %m48 = mul i32 %h47, 31
  %h48 = add i32 %m48, %r48
  %r49 = call i32 @f49(i64 %a)
  %m49 = mul i32 %h48, 31
  %h49 = add i32 %m49, %r49
  %r50 = call i32 @f50(i64 %a)
  %m50 = mul i32 %h49, 31
  %h50 = add i32 %m50, %r50
  %r51 = call i32 @f51(i64 %a)
  %m51 = mul i32 %h50, 31
  %h51 = add i32 %m51, %r51
  %r52 = call i32 @f52(i64 %a)
  %m52 = mul i32 %h51, 31
  %h52 = add i32 %m52, %r52
  %r53 = call i32 @f53(i64 %a)
  %m53 = mul i32 %h52, 31
  %h53 = add i32 %m53, %r53
  %r54 = call i32 @f54(i64 %a)
  %m54 = mul i32 %h53, 31
  %h54 = add i32 %m54, %r54
  %r55 = call i32 @f55(i64 %a)
  %m55 = mul i32 %h54, 31
  %h55 = add i32 %m55, %r55
  %r56 = call i32 @f56(i64 %a)
  %m56 = mul i32 %h55, 31
  %h56 = add i32 %m56, %r56
  %r57 = call i32 @f57(i64 %a)
  %m57 = mul i32 %h56, 31
  %h57 = add i32 %m57, %r57
  %r58 = call i32 @f58(i64 %a)
  %m58 = mul i32 %h57, 31
  %h58 = add i32 %m58, %r58
  %r59 = call i32 @f59(i64 %a)
  %m59 = mul i32 %h58, 31
  %h59 = add i32 %m59, %r59
  %r60 = call i32 @f60(i64 %a)
  %m60 = mul i32 %h59, 31
  %h60 = add i32 %m60, %r60
  %r61 = call i32 @f61(i64 %a)
  %m61 = mul i32 %h60, 31
  %h61 = add i32 %m61, %r61
  %r62 = call i32 @f62(i64 %a)
  %m62 = mul i32 %h61, 31
  %h62 = add i32 %m62, %r62
  %r63 = call i32 @f63(i64 %a)
  %m63 = mul i32 %h62, 31
  %h63 = add i32 %m63, %r63
  %r64 = call i32 @f64(i64 %a)
  %m64 = mul i32 %h63, 31
  %h64 = add i32 %m64, %r64
  %r65 = call i32 @f65(i64 %a)
  %m65 = mul i32 %h64, 31
  %h65 = add i32 %m65, %r65
  %r66 = call i32 @f66(i64 %a)
  %m66 = mul i32 %h65, 31
  %h66 = add i32 %m66, %r66
  %r67 = call i32 @f67(i64 %a)
  %m67 = mul i32 %h66, 31
  %h67 = add i32 %m67, %r67
  %r68 = call i32 @f68(i64 %a)
  %m68 = mul i32 %h67, 31
  %h68 = add i32 %m68, %r68
  %r69 = call i32 @f69(i64 %a)
  %m69 = mul i32 %h68, 31
  %h69 = add i32 %m69, %r69
  %r70 = call i32 @f70(i64 %a)
  %m70 = mul i32 %h69, 31
  %h70 = add i32 %m70, %r70
  %r71 = call i32 @f71(i64 %a)
  %m71 = mul i32 %h70, 31
  %h71 = add i32 %m71, %r71
  %r72 = call i32 @f72(i64 %a)
  %m72 = mul i32 %h71, 31
  %h72 = add i32 %m72, %r72
  %r73 = call i32 @f73(i64 %a)
  %m73 = mul i32 %h72, 31
  %h73 = add i32 %m73, %r73
  %r74 = call i32 @f74(i64 %a)
  %m74 = mul i32 %h73, 31
  %h74 = add i32 %m74, %r74
  %r75 = call i32 @f75(i64 %a)
  %m75 = mul i32 %h74, 31
  %h75 = add i32 %m75, %r75
  %r76 = call i32 @f76(i64 %a)
  %m76 = mul i32 %h75, 31
  %h76 = add i32 %m76, %r76
  %r77 = call i32 @f77(i64 %a)
  %m77 = mul i32 %h76, 31
  %h77 = add i32 %m77, %r77
  %r78 = call i32 @f78(i64 %a)
  %m78 = mul i32 %h77, 31
  %h78 = add i32 %m78, %r78
  %r79 = call i32 @f79(i64 %a)
  %m79 = mul i32 %h78, 31
  %h79 = add i32 %m79, %r79
  %r80 = call i32 @f80(i64 %a)
  %m80 = mul i32 %h79, 31
  %h80 = add i32 %m80, %r80
  %r81 = call i32 @f81(i64 %a)
  %m81 = mul i32 %h80, 31
  %h81 = add i32 %m81, %r81
  %r82 = call i32 @f82(i64 %a)
  %m82 = mul i32 %h81, 31
  %h82 = add i32 %m82, %r82
  %r83 = call i32 @f83(i64 %a)
  %m83 = mul i32 %h82, 31
  %h83 = add i32 %m83, %r83
  %r84 = call i32 @f84(i64 %a)
  %m84 = mul i32 %h83, 31
  %h84 = add i32 %m84, %r84
  %r85 = call i32 @f85(i64 %a)
  %m85 = mul i32 %h84, 31
  %h85 = add i32 %m85, %r85
  %r86 = call i32 @f86(i64 %a)
  %m86 = mul i32 %h85, 31
  %h86 = add i32 %m86, %r86
  %r87 = call i32 @f87(i64 %a)
  %m87 = mul i32 %h86, 31
  %h87 = add i32 %m87, %r87
  %r88 = call i32 @f88(i64 %a)
  %m88 = mul i32 %h87, 31
  %h88 = add i32 %m88, %r88
  %r89 = call i32 @f89(i64 %a)
  %m89 = mul i32 %h88, 31
  %h89 = add i32 %m89, %r89
  %r90 = call i32 @f90(i64 %a)
  %m90 = mul i32 %h89, 31
  %h90 = add i32 %m90, %r90
  %r91 = call i32 @f91(i64 %a)
  %m91 = mul i32 %h90, 31
  %h91 = add i32 %m91, %r91
  %r92 = call i32 @f92(i64 %a)
  %m92 = mul i32 %h91, 31
  %h92 = add i32 %m92, %r92
  %r93 = call i32 @f93(i64 %a)
  %m93 = mul i32 %h92, 31
  %h93 = add i32 %m93, %r93
  %r94 = call i32 @f94(i64 %a)
  %m94 = mul i32 %h93, 31
  %h94 = add i32 %m94, %r94
  %r95 = call i32 @f95(i64 %a)
  %m95 = mul i32 %h94, 31
  %h95 = add i32 %m95, %r95
  %r96 = call i32 @f96(i64 %a)
  %m96 = mul i32 %h95, 31
  %h96 = add i32 %m96, %r96
  %r97 = call i32 @f97(i64 %a)
  %m97 = mul i32 %h96, 31
  %h97 = add i32 %m97, %r97
  %r98 = call i32 @f98(i64 %a)
  %m98 = mul i32 %h97, 31
  %h98 = add i32 %m98, %r98
  %r99 = call i32 @f99(i64 %a)
  %m99 = mul i32 %h98, 31
  %h99 = add i32 %m99, %r99
  %r100 = call i32 @f100(i64 %a)
  %m100 = mul i32 %h99, 31
  %h100 = add i32 %m100, %r100
  %r101 = call i32 @f101(i64 %a)
  %m101 = mul i32 %h100, 31
  %h101 = add i32 %m101, %r101
  %r102 = call i32 @f102(i64 %a)
  %m102 = mul i32 %h101, 31
  %h102 = add i32 %m102, %r102
  %r103 = call i32 @f103(i64 %a)
  %m103 = mul i32 %h102, 31
  %h103 = add i32 %m103, %r103
  %r104 = call i32 @f104(i64 %a)
  %m104 = mul i32 %h103, 31
  %h104 = add i32 %m104, %r104
  %r105 = call i32 @f105(i64 %a)
  %m105 = mul i32 %h104, 31
  %h105 = add i32 %m105, %r105
  %r106 = call i32 @f106(i64 %a)
  %m106 = mul i32 %h105, 31
  %h106 = add i32 %m106, %r106
  %r107 = call i32 @f107(i64 %a)
  %m107 = mul i32 %h106, 31
  %h107 = add i32 %m107, %r107
  %r108 = call i32 @f108(i64 %a)
  %m108 = mul i32 %h107, 31
  %h108 = add i32 %m108, %r108
  %r109 = call i32 @f109(i64 %a)
  %m109 = mul i32 %h108, 31
  %h109 = add i32 %m109, %r109
  %r110 = call i32 @f110(i64 %a)
  %m110 = mul i32 %h109, 31
  %h110 = add i32 %m110, %r110
  %r111 = call i32 @f111(i64 %a)
  %m111 = mul i32 %h110, 31
  %h111 = add i32 %m111, %r111
  %r112 = call i32 @f112(i64 %a)
  %m112 = mul i32 %h111, 31
  %h112 = add i32 %m112, %r112
  %r113 = call i32 @f113(i64 %a)
  %m113 = mul i32 %h112, 31
  %h113 = add i32 %m113, %r113
  %r114 = call i32 @f114(i64 %a)
  %m114 = mul i32 %h113, 31
  %h114 = add i32 %m114, %r114
  %r115 = call i32 @f115(i64 %a)
  %m115 = mul i32 %h114, 31
  %h115 = add i32 %m115, %r115
  %r116 = call i32 @f116(i64 %a)
  %m116 = mul i32 %h115, 31
  %h116 = add i32 %m116, %r116
  %r117 = call i32 @f117(i64 %a)
  %m117 = mul i32 %h116, 31
  %h117 = add i32 %m117, %r117
  %r118 = call i32 @f118(i64 %a)
  %m118 = mul i32 %h117, 31
  %h118 = add i32 %m118, %r118
  %r119 = call i32 @f119(i64 %a)
  %m119 = mul i32 %h118, 31
  %h119 = add i32 %m119, %r119
  %r120 = call i32 @f120(i64 %a)
  %m120 = mul i32 %h119, 31
  %h120 = add i32 %m120, %r120
  %r121 = call i32 @f121(i64 %a)
  %m121 = mul i32 %h120, 31
  %h121 = add i32 %m121, %r121
  %r122 = call i32 @f122(i64 %a)
  %m122 = mul i32 %h121, 31
  %h122 = add i32 %m122, %r122
  %r123 = call i32 @f123(i64 %a)
  %m123 = mul i32 %h122, 31
  %h123 = add i32 %m123, %r123
  %r124 = call i32 @f124(i64 %a)
  %m124 = mul i32 %h123, 31
  %h124 = add i32 %m124, %r124
  %r125 = call i32 @f125(i64 %a)
  %m125 = mul i32 %h124, 31
  %h125 = add i32 %m125, %r125
  %r126 = call i32 @f126(i64 %a)
  %m126 = mul i32 %h125, 31
  %h126 = add i32 %m126, %r126
  %r127 = call i32 @f127(i64 %a)
  %m127 = mul i32 %h126, 31
  %h127 = add i32 %m127, %r127
  %r128 = call i32 @f128(i64 %a)
  %m128 = mul i32 %h127, 31
  %h128 = add i32 %m128, %r128
  %r129 = call i32 @f129(i64 %a)
  %m129 = mul i32 %h128, 31
  %h129 = add i32 %m129, %r129
  %r130 = call i32 @f130(i64 %a)
  %m130 = mul i32 %h129, 31
  %h130 = add i32 %m130, %r130
  %r131 = call i32 @f131(i64 %a)
  %m131 = mul i32 %h130, 31
  %h131 = add i32 %m131, %r131
  %r132 = call i32 @f132(i64 %a)
  %m132 = mul i32 %h131, 31
  %h132 = add i32 %m132, %r132
  %r133 = call i32 @f133(i64 %a)
  %m133 = mul i32 %h132, 31
  %h133 = add i32 %m133, %r133
  %r134 = call i32 @f134(i64 %a)
  %m134 = mul i32 %h133, 31
  %h134 = add i32 %m134, %r134
  %r135 = call i32 @f135(i64 %a)
  %m135 = mul i32 %h134, 31
  %h135 = add i32 %m135, %r135
  %r136 = call i32 @f136(i64 %a)
  %m136 = mul i32 %h135, 31
  %h136 = add i32 %m136, %r136
  %r137 = call i32 @f137(i64 %a)
  %m137 = mul i32 %h136, 31
  %h137 = add i32 %m137, %r137
  %r138 = call i32 @f138(i64 %a)
  %m138 = mul i32 %h137, 31
  %h138 = add i32 %m138, %r138
  %r139 = call i32 @f139(i64 %a)
  %m139 = mul i32 %h138, 31
  %h139 = add i32 %m139, %r139
  %r140 = call i32 @f140(i64 %a)
  %m140 = mul i32 %h139, 31
  %h140 = add i32 %m140, %r140
  %r141 = call i32 @f141(i64 %a)
  %m141 = mul i32 %h140, 31
  %h141 = add i32 %m141, %r141
  %r142 = call i32 @f142(i64 %a)
  %m142 = mul i32 %h141, 31
  %h142 = add i32 %m142, %r142
  %r143 = call i32 @f143(i64 %a)
  %m143 = mul i32 %h142, 31
  %h143 = add i32 %m143, %r143
  %r144 = call i32 @f144(i64 %a)
  %m144 = mul i32 %h143, 31
  %h144 = add i32 %m144, %r144
  %r145 = call i32 @f145(i64 %a)
  %m145 = mul i32 %h144, 31
  %h145 = add i32 %m145, %r145
  %r146 = call i32 @f146(i64 %a)
  %m146 = mul i32 %h145, 31
  %h146 = add i32 %m146, %r146
  %r147 = call i32 @f147(i64 %a)
  %m147 = mul i32 %h146, 31
  %h147 = add i32 %m147, %r147
  %r148 = call i32 @f148(i64 %a)
  %m148 = mul i32 %h147, 31
  %h148 = add i32 %m148, %r148
  %r149 = call i32 @f149(i64 %a)
  %m149 = mul i32 %h148, 31
  %h149 = add i32 %m149, %r149
  %r150 = call i32 @f150(i64 %a)
  %m150 = mul i32 %h149, 31
  %h150 = add i32 %m150, %r150
  %r151 = call i32 @f151(i64 %a)
  %m151 = mul i32 %h150, 31
  %h151 = add i32 %m151, %r151
  %r152 = call i32 @f152(i64 %a)
  %m152 = mul i32 %h151, 31
  %h152 = add i32 %m152, %r152
  %r153 = call i32 @f153(i64 %a)
  %m153 = mul i32 %h152, 31
  %h153 = add i32 %m153, %r153
  %r154 = call i32 @f154(i64 %a)
  %m154 = mul i32 %h153, 31
  %h154 = add i32 %m154, %r154
  %r155 = call i32 @f155(i64 %a)
  %m155 = mul i32 %h154, 31
  %h155 = add i32 %m155, %r155
  %r156 = call i32 @f156(i64 %a)
  %m156 = mul i32 %h155, 31
  %h156 = add i32 %m156, %r156
  %r157 = call i32 @f157(i64 %a)
  %m157 = mul i32 %h156, 31
  %h157 = add i32 %m157, %r157
  %r158 = call i32 @f158(i64 %a)
  %m158 = mul i32 %h157, 31
  %h158 = add i32 %m158, %r158
  %r159 = call i32 @f159(i64 %a)
  %m159 = mul i32 %h158, 31
  %h159 = add i32 %m159, %r159
  %r160 = call i32 @f160(i64 %a)
  %m160 = mul i32 %h159, 31
  %h160 = add i32 %m160, %r160
  %r161 = call i32 @f161(i64 %a)
  %m161 = mul i32 %h160, 31
  %h161 = add i32 %m161, %r161
  %r162 = call i32 @f162(i64 %a)
  %m162 = mul i32 %h161, 31
  %h162 = add i32 %m162, %r162
  %r163 = call i32 @f163(i64 %a)
  %m163 = mul i32 %h162, 31
  %h163 = add i32 %m163, %r163
  %r164 = call i32 @f164(i64 %a)
  %m164 = mul i32 %h163, 31
  %h164 = add i32 %m164, %r164
  %r165 = call i32 @f165(i64 %a)
  %m165 = mul i32 %h164, 31
  %h165 = add i32 %m165, %r165
  %r166 = call i32 @f166(i64 %a)
  %m166 = mul i32 %h165, 31
  %h166 = add i32 %m166, %r166
  %r167 = call i32 @f167(i64 %a)
  %m167 = mul i32 %h166, 31
  %h167 = add i32 %m167, %r167
  %r168 = call i32 @f168(i64 %a)
  %m168 = mul i32 %h167, 31
  %h168 = add i32 %m168, %r168
  %r169 = call i32 @f169(i64 %a)
  %m169 = mul i32 %h168, 31
  %h169 = add i32 %m169, %r169
  %r170 = call i32 @f170(i64 %a)
  %m170 = mul i32 %h169, 31
  %h170 = add i32 %m170, %r170
  %r171 = call i32 @f171(i64 %a)
  %m171 = mul i32 %h170, 31
  %h171 = add i32 %m171, %r171
  %r172 = call i32 @f172(i64 %a)
  %m172 = mul i32 %h171, 31
  %h172 = add i32 %m172, %r172
  %r173 = call i32 @f173(i64 %a)
  %m173 = mul i32 %h172, 31
  %h173 = add i32 %m173, %r173
  %r174 = call i32 @f174(i64 %a)
  %m174 = mul i32 %h173, 31
  %h174 = add i32 %m174, %r174
  %r175 = call i32 @f175(i64 %a)
  %m175 = mul i32 %h174, 31
  %h175 = add i32 %m175, %r175
  %r176 = call i32 @f176(i64 %a)
  %m176 = mul i32 %h175, 31
  %h176 = add i32 %m176, %r176
  %r177 = call i32 @f177(i64 %a)
  %m177 = mul i32 %h176, 31
  %h177 = add i32 %m177, %r177
  %r178 = call i32 @f178(i64 %a)
  %m178 = mul i32 %h177, 31
  %h178 = add i32 %m178, %r178
  %r179 = call i32 @f179(i64 %a)
  %m179 = mul i32 %h178, 31
  %h179 = add i32 %m179, %r179
  %r180 = call i32 @f180(i64 %a)
  %m180 = mul i32 %h179, 31
  %h180 = add i32 %m180, %r180
  %r181 = call i32 @f181(i64 %a)
  %m181 = mul i32 %h180, 31
  %h181 = add i32 %m181, %r181
  %r182 = call i32 @f182(i64 %a)
  %m182 = mul i32 %h181, 31
  %h182 = add i32 %m182, %r182
  %r183 = call i32 @f183(i64 %a)
  %m183 = mul i32 %h182, 31
  %h183 = add i32 %m183, %r183
  %r184 = call i32 @f184(i64 %a)
  %m184 = mul i32 %h183, 31
  %h184 = add i32 %m184, %r184
  %r185 = call i32 @f185(i64 %a)
  %m185 = mul i32 %h184, 31
  %h185 = add i32 %m185, %r185
  %r186 = call i32 @f186(i64 %a)
  %m186 = mul i32 %h185, 31
  %h186 = add i32 %m186, %r186
  %r187 = call i32 @f187(i64 %a)
  %m187 = mul i32 %h186, 31
  %h187 = add i32 %m187, %r187
  %r188 = call i32 @f188(i64 %a)
  %m188 = mul i32 %h187, 31
  %h188 = add i32 %m188, %r188
  %r189 = call i32 @f189(i64 %a)
  %m189 = mul i32 %h188, 31
  %h189 = add i32 %m189, %r189
  %r190 = call i32 @f190(i64 %a)
  %m190 = mul i32 %h189, 31
  %h190 = add i32 %m190, %r190
  %r191 = call i32 @f191(i64 %a)
  %m191 = mul i32 %h190, 31
  %h191 = add i32 %m191, %r191
  %r192 = call i32 @f192(i64 %a)
  %m192 = mul i32 %h191, 31
  %h192 = add i32 %m192, %r192
  %r193 = call i32 @f193(i64 %a)
  %m193 = mul i32 %h192, 31
  %h193 = add i32 %m193, %r193
  %r194 = call i32 @f194(i64 %a)
  %m194 = mul i32 %h193, 31
  %h194 = add i32 %m194, %r194
  %r195 = call i32 @f195(i64 %a)
  %m195 = mul i32 %h194, 31
  %h195 = add i32 %m195, %r195
  %r196 = call i32 @f196(i64 %a)
  %m196 = mul i32 %h195, 31
  %h196 = add i32 %m196, %r196
  %r197 = call i32 @f197(i64 %a)
  %m197 = mul i32 %h196, 31
  %h197 = add i32 %m197, %r197
  %r198 = call i32 @f198(i64 %a)
  %m198 = mul i32 %h197, 31
  %h198 = add i32 %m198, %r198
  %r199 = call i32 @f199(i64 %a)
  %m199 = mul i32 %h198, 31
  %h199 = add i32 %m199, %r199
  %r200 = call i32 @f200(i64 %a)
  %m200 = mul i32 %h199, 31
  %h200 = add i32 %m200, %r200
  %r201 = call i32 @f201(i64 %a)
  %m201 = mul i32 %h200, 31
  %h201 = add i32 %m201, %r201
  %r202 = call i32 @f202(i64 %a)
  %m202 = mul i32 %h201, 31
  %h202 = add i32 %m202, %r202
  %r203 = call i32 @f203(i64 %a)
  %m203 = mul i32 %h202, 31
  %h203 = add i32 %m203, %r203
  %r204 = call i32 @f204(i64 %a)
  %m204 = mul i32 %h203, 31
  %h204 = add i32 %m204, %r204
  %r205 = call i32 @f205(i64 %a)
  %m205 = mul i32 %h204, 31
  %h205 = add i32 %m205, %r205
  %r206 = call i32 @f206(i64 %a)
  %m206 = mul i32 %h205, 31
  %h206 = add i32 %m206, %r206
  %r207 = call i32 @f207(i64 %a)
  %m207 = mul i32 %h206, 31
  %h207 = add i32 %m207, %r207
  %r208 = call i32 @f208(i64 %a)
  %m208 = mul i32 %h207, 31
  %h208 = add i32 %m208, %r208
  %r209 = call i32 @f209(i64 %a)
  %m209 = mul i32 %h208, 31
  %h209 = add i32 %m209, %r209
  %r210 = call i32 @f210(i64 %a)
  %m210 = mul i32 %h209, 31
  %h210 = add i32 %m210, %r210
  %r211 = call i32 @f211(i64 %a)
  %m211 = mul i32 %h210, 31
  %h211 = add i32 %m211, %r211
  %r212 = call i32 @f212(i64 %a)
  %m212 = mul i32 %h211, 31
  %h212 = add i32 %m212, %r212
  %r213 = call i32 @f213(i64 %a)
  %m213 = mul i32 %h212, 31
  %h213 = add i32 %m213, %r213
  %r214 = call i32 @f214(i64 %a)
  %m214 = mul i32 %h213, 31
  %h214 = add i32 %m214, %r214
  %r215 = call i32 @f215(i64 %a)
  %m215 = mul i32 %h214, 31
  %h215 = add i32 %m215, %r215
  %r216 = call i32 @f216(i64 %a)
  %m216 = mul i32 %h215, 31
  %h216 = add i32 %m216, %r216
  %r217 = call i32 @f217(i64 %a)
  %m217 = mul i32 %h216, 31
  %h217 = add i32 %m217, %r217
  %r218 = call i32 @f218(i64 %a)
  %m218 = mul i32 %h217, 31
  %h218 = add i32 %m218, %r218
  %r219 = call i32 @f219(i64 %a)
  %m219 = mul i32 %h218, 31
  %h219 = add i32 %m219, %r219
  %r220 = call i32 @f220(i64 %a)
  %m220 = mul i32 %h219, 31
  %h220 = add i32 %m220, %r220
  %r221 = call i32 @f221(i64 %a)
  %m221 = mul i32 %h220, 31
  %h221 = add i32 %m221, %r221
  %r222 = call i32 @f222(i64 %a)
  %m222 = mul i32 %h221, 31
  %h222 = add i32 %m222, %r222
  %r223 = call i32 @f223(i64 %a)
  %m223 = mul i32 %h222, 31
  %h223 = add i32 %m223, %r223
  %r224 = call i32 @f224(i64 %a)
  %m224 = mul i32 %h223, 31
  %h224 = add i32 %m224, %r224
  %r225 = call i32 @f225(i64 %a)
  %m225 = mul i32 %h224, 31
  %h225 = add i32 %m225, %r225
  %r226 = call i32 @f226(i64 %a)
  %m226 = mul i32 %h225, 31
  %h226 = add i32 %m226, %r226
  %r227 = call i32 @f227(i64 %a)
  %m227 = mul i32 %h226, 31
  %h227 = add i32 %m227, %r227
  %r228 = call i32 @f228(i64 %a)
  %m228 = mul i32 %h227, 31
  %h228 = add i32 %m228, %r228
  %r229 = call i32 @f229(i64 %a)
  %m229 = mul i32 %h228, 31
  %h229 = add i32 %m229, %r229
  %r230 = call i32 @f230(i64 %a)
  %m230 = mul i32 %h229, 31
  %h230 = add i32 %m230, %r230
  %r231 = call i32 @f231(i64 %a)
  %m231 = mul i32 %h230, 31
  %h231 = add i32 %m231, %r231
  %r232 = call i32 @f232(i64 %a)
  %m232 = mul i32 %h231, 31
  %h232 = add i32 %m232, %r232
  %r233 = call i32 @f233(i64 %a)
  %m233 = mul i32 %h232, 31
  %h233 = add i32 %m233, %r233
  %r234 = call i32 @f234(i64 %a)
  %m234 = mul i32 %h233, 31
  %h234 = add i32 %m234, %r234
  %r235 = call i32 @f235(i64 %a)
  %m235 = mul i32 %h234, 31
  %h235 = add i32 %m235, %r235
  %r236 = call i32 @f236(i64 %a)
  %m236 = mul i32 %h235, 31
  %h236 = add i32 %m236, %r236
  %r237 = call i32 @f237(i64 %a)
  %m237 = mul i32 %h236, 31
  %h237 = add i32 %m237, %r237
  %r238 = call i32 @f238(i64 %a)
  %m238 = mul i32 %h237, 31
  %h238 = add i32 %m238, %r238
  %r239 = call i32 @f239(i64 %a)
  %m239 = mul i32 %h238, 31
  %h239 = add i32 %m239, %r239
  %accj = add i32 %h239, 0
  br label %ol
ol:
  %in = add i64 %i, 1
  %id = icmp eq i64 %in, 44
  br i1 %id, label %done, label %oi
done:
  ret i32 %accj
}
