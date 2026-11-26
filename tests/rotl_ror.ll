; expect: 1  -- a rotate left by a constant is a rotate right by 64 minus the constant (ror is the one instruction; rol is only the assembler's spelling), a rotate right keeps its count
declare i64 @llvm.fshl.i64(i64, i64, i64)
declare i64 @llvm.fshr.i64(i64, i64, i64)
define i32 @test() {
  %v = add i64 81985529216486895, 0
  %l = call i64 @llvm.fshl.i64(i64 %v, i64 %v, i64 13)
  %r = call i64 @llvm.fshr.i64(i64 %v, i64 %v, i64 7)
  %l3 = call i64 @llvm.fshl.i64(i64 %v, i64 %v, i64 3)
  ; 0x0123456789abcdef rotl 13 = 0x68acf13579bde024, rotr 7 = 0xde02468acf13579b, rotl 3 = 0x091a2b3c4d5e6f78
  %e1 = icmp eq i64 %l, 7542668687916785700
  %e2 = icmp eq i64 %r, -2449317685342546021
  %e3 = icmp eq i64 %l3, 655884233731895160
  %a = and i1 %e1, %e2
  %b = and i1 %a, %e3
  %z = zext i1 %b to i32
  ret i32 %z
}
