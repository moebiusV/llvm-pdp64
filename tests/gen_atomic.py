#!/usr/bin/env python3
"""gen_atomic.py -- writes tests/atomic_*.ll, the LLVM atomic operations lowered to the pdp64 atomic words (errata 211): atomicrmw of every operation, cmpxchg, atomic load and store, fence.
The expected value of each (the first line, `; expect: N`) is computed here by a model of the operations, not by llc; check.sh runs the programs under sim64.
    python3 tests/gen_atomic.py"""
import os
HERE = os.path.dirname(os.path.abspath(__file__))
M = {8: (1 << 8) - 1, 16: (1 << 16) - 1, 32: (1 << 32) - 1, 64: (1 << 64) - 1}


def sx(v, b):
    v &= (1 << b) - 1
    return v - (1 << b) if v >> (b - 1) else v


def apply(op, b, g, v):
    m = M[b]
    v &= m
    return {'add': (g + v) & m, 'sub': (g - v) & m, 'and': g & v, 'or': g | v, 'xor': g ^ v, 'nand': ~(g & v) & m, 'xchg': v,
            'max': g if sx(g, b) > sx(v, b) else v, 'min': g if sx(g, b) < sx(v, b) else v, 'umax': max(g, v), 'umin': min(g, v)}[op]


ORD = ['seq_cst', 'acq_rel', 'monotonic', 'seq_cst', 'acquire', 'release']


def rmw_test(name, b, g0, ops, why):
    """one global of b bits; the old value of each operation is folded into an i64 accumulator (acc = acc * 31 + sext(old)), the final value of the global is folded last"""
    g = g0 & M[b]
    acc = 0
    ir = ['define i32 @test() {', '  %acc0 = add i64 0, 0']
    for i, (op, v) in enumerate(ops):
        old = g
        g = apply(op, b, g, v)
        acc = (acc * 31 + sx(old, b)) & M[64]
        ir.append('  %%o%d = atomicrmw %s ptr @g, i%d %d %s' % (i, op, b, sx(v, b), ORD[i % len(ORD)]))
        ir.append(('  %%x%d = sext i%d %%o%d to i64' % (i, b, i)) if b != 64 else ('  %%x%d = add i64 %%o%d, 0' % (i, i)))
        ir.append('  %%m%d = mul i64 %%acc%d, 31' % (i, i))
        ir.append('  %%acc%d = add i64 %%m%d, %%x%d' % (i + 1, i, i))
    ir.append('  %%f = load i%d, ptr @g' % b)
    ir.append(('  %%fx = sext i%d %%f to i64' % b) if b != 64 else '  %fx = add i64 %f, 0')
    ir.append('  %%fm = mul i64 %%acc%d, 31' % len(ops))
    ir.append('  %fa = add i64 %fm, %fx')
    ir.append('  %r = trunc i64 %fa to i32')
    ir.append('  ret i32 %r')
    ir.append('}')
    acc = (acc * 31 + sx(g, b)) & M[64]
    exp = sx(acc, 32)
    src = '; expect: %d  -- %s\n@g = global i%d %d\n' % (exp, why, b, sx(g0, b)) + '\n'.join(ir) + '\n'
    open(os.path.join(HERE, name + '.ll'), 'w').write(src)


ALL = ['add', 'sub', 'and', 'or', 'xor', 'max', 'umax', 'umin', 'xchg', 'nand', 'min', 'xor']
VALS = {64: [5, 3, 10, 3, 1, -5, -5, 7, 100, 12, -1, 0], 32: [5, 3, 10, 3, 1, -5, -5, 7, 100, 12, -1, 0], 16: [5, 3, 10, 3, 1, -5, -5, 7, 100, 12, -1, 0], 8: [5, 3, 10, 3, 1, -5, -5, 7, 100, 12, -1, 0]}
for b, why in ((64, 'every atomicrmw operation on 8 bytes (swap, add, sub, and, or, xor, max, min, umax, umin are instructions or an add of the negation; nand is a compare-and-swap loop)'),
               (32, 'every atomicrmw operation on 4 bytes (the l words; the old value comes back sign-extended)'),
               (16, 'every atomicrmw operation on 2 bytes (a compare-and-swap loop on the 4-byte word that holds it)'),
               (8, 'every atomicrmw operation on a byte (a compare-and-swap loop on the 4-byte word that holds it)')):
    rmw_test('atomic_rmw%d' % b, b, 10 if b == 64 else 0x80000010 if b == 32 else 0x8010 if b == 16 else 0x90, list(zip(ALL, VALS[b])), why)
# the signed and unsigned maximum and minimum with values on both sides of zero in 4 bytes, where a wrong comparison width shows
rmw_test('atomic_rmw32_cmp', 32, 0x7FFFFFF0, [('max', -1), ('umax', -1), ('min', 5), ('umin', 5), ('max', 0x7FFFFFFF), ('add', 0x7FFFFFFF), ('add', 0x7FFFFFFF)], '4-byte maximum and minimum, signed and unsigned, and the wrap of an add')

# compare and swap: success and failure, 8 and 4 bytes, the old value, the flag and the memory after
def cas_test():
    cases = [(64, 100, 100, 200, 'seq_cst', 'seq_cst'), (64, 100, 150, 300, 'seq_cst', 'seq_cst'), (32, 0x80000001, 0x80000001, 7, 'acq_rel', 'acquire'),
             (32, 7, -1, 9, 'monotonic', 'monotonic'), (32, 7, 7, 9, 'seq_cst', 'monotonic')]
    ir = ['define i32 @test() {', '  %acc0 = add i64 0, 0']
    acc = 0
    for i, (b, g, e, n, so, fo) in enumerate(cases):
        ptr = '@g8' if b == 64 else '@g4'
        ir.append('  store i%d %d, ptr %s' % (b, sx(g, b), ptr))               # every case starts from its own memory
        ir.append('  %%p%d = cmpxchg ptr %s, i%d %d, i%d %d %s %s' % (i, ptr, b, sx(e, b), b, sx(n, b), so, fo))
        ir.append('  %%v%d = extractvalue { i%d, i1 } %%p%d, 0' % (i, b, i))
        ir.append('  %%s%d = extractvalue { i%d, i1 } %%p%d, 1' % (i, b, i))
        ir.append(('  %%vx%d = sext i%d %%v%d to i64' % (i, b, i)) if b != 64 else ('  %%vx%d = add i64 %%v%d, 0' % (i, i)))
        ir.append('  %%sx%d = zext i1 %%s%d to i64' % (i, i))
        ir.append('  %%l%d = load i%d, ptr %s' % (i, b, ptr))
        ir.append(('  %%lx%d = sext i%d %%l%d to i64' % (i, b, i)) if b != 64 else ('  %%lx%d = add i64 %%l%d, 0' % (i, i)))
        ok = (g & M[b]) == (e & M[b])
        mem = (n & M[b]) if ok else (g & M[b])
        for k, term in enumerate((sx(g, b), int(ok), sx(mem, b))):
            acc = (acc * 31 + term) & M[64]
        ir.append('  %%a%d = mul i64 %%acc%d, 31' % (i, i))
        ir.append('  %%b%d = add i64 %%a%d, %%vx%d' % (i, i, i))
        ir.append('  %%c%d = mul i64 %%b%d, 31' % (i, i))
        ir.append('  %%d%d = add i64 %%c%d, %%sx%d' % (i, i, i))
        ir.append('  %%e%d = mul i64 %%d%d, 31' % (i, i))
        ir.append('  %%acc%d = add i64 %%e%d, %%lx%d' % (i + 1, i, i))
    ir.append('  %%r = trunc i64 %%acc%d to i32' % len(cases))
    ir.append('  ret i32 %r')
    ir.append('}')
    return ir, sx(acc, 32)
ir, e = cas_test()
open(os.path.join(HERE, 'atomic_cmpxchg.ll'), 'w').write('; expect: %d  -- cmpxchg: the old value, the success flag and the memory after, for 8 and 4 bytes, on success and on failure (the expected value and the old value are one register)\n@g8 = global i64 100\n@g4 = global i32 -2147483647\n' % e + '\n'.join(ir) + '\n')

# atomic load and store of every size, a fence between them (a fence is nothing on a sequentially consistent machine)
def ls_test():
    ir = ['@a8 = global i8 0', '@a16 = global i16 0', '@a32 = global i32 0', '@a64 = global i64 0', 'define i32 @test() {']
    vals = [(8, -100), (16, -30000), (32, -2000000000), (64, -9000000000000000000)]
    acc = 0
    for i, (b, v) in enumerate(vals):
        ir.append('  store atomic i%d %d, ptr @a%d seq_cst, align %d' % (b, v, b, b // 8))
        ir.append('  fence seq_cst')
        ir.append('  %%l%d = load atomic i%d, ptr @a%d acquire, align %d' % (i, b, b, b // 8))
        ir.append(('  %%x%d = sext i%d %%l%d to i64' % (i, b, i)) if b != 64 else ('  %%x%d = add i64 %%l%d, 0' % (i, i)))
        acc = (acc * 31 + v) & M[64]
    ir.append('  %m0 = mul i64 0, 31\n  %s0 = add i64 %m0, %x0')
    for i in range(1, 4):
        ir.append('  %%m%d = mul i64 %%s%d, 31\n  %%s%d = add i64 %%m%d, %%x%d' % (i, i - 1, i, i, i))
    ir.append('  %r = trunc i64 %s3 to i32\n  ret i32 %r\n}')
    return ir, sx(acc, 32)
ir, e = ls_test()
open(os.path.join(HERE, 'atomic_loadstore.ll'), 'w').write('; expect: %d  -- atomic load and store of 1, 2, 4 and 8 bytes are ordinary ones, and a fence is no instruction\n' % e + '\n'.join(ir) + '\n')
