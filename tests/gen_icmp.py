#!/usr/bin/env python3
"""gen_icmp.py -- writes tests/icmp_*.ll: every integer condition (eq ne slt sle sgt sge ult ule ugt uge) against constants around the edges of the immediate fields (the
setCC immediate is 8 bits signed: -129 -128 127 128; the cbCC immediate 16 bits, and 12 bits for the signed conditions: 2047 2048 32767 32768) and against a register, as the value of
the compare (zext of an i1: setCC), as a select, and as a branch; i64 and i32.  Expected values are computed here by a model.
    python3 tests/gen_icmp.py"""
import os
HERE = os.path.dirname(os.path.abspath(__file__))
CC = ['eq', 'ne', 'slt', 'sle', 'sgt', 'sge', 'ult', 'ule', 'ugt', 'uge']
IMMS = [-32769, -32768, -2049, -2048, -129, -128, -127, -1, 0, 1, 126, 127, 128, 129, 2047, 2048, 32767, 32768, 65535, 2**31 - 1, -2**31, 2**40, -2**63, 2**63 - 1]
A = [-2**63, -2**63 + 1, -2**31 - 1, -2**31, -65536, -32770, -32769, -32768, -32767, -2050, -2049, -2048, -2047, -130, -129, -128, -127, -126, -2, -1, 0, 1, 2, 126, 127, 128, 129,
     2046, 2047, 2048, 2049, 32766, 32767, 32768, 32769, 65535, 65536, 2**31 - 1, 2**31, 2**32 - 1, 2**32, 2**40, 2**63 - 2, 2**63 - 1]


def wrap(v, b):
    v &= (1 << b) - 1
    return v - (1 << b) if v >> (b - 1) else v


def wrap32(v):
    return wrap(v, 32)


def model(cc, a, b, bits):
    sa, sb = wrap(a, bits), wrap(b, bits)
    ua, ub = sa & ((1 << bits) - 1), sb & ((1 << bits) - 1)
    return {'eq': sa == sb, 'ne': sa != sb, 'slt': sa < sb, 'sle': sa <= sb, 'sgt': sa > sb, 'sge': sa >= sb, 'ult': ua < ub, 'ule': ua <= ub, 'ugt': ua > ub, 'uge': ua >= ub}[cc]


def gen(kind, form, bits):
    ty = 'i%d' % bits
    imms = [wrap(i, bits) for i in IMMS] if form == 'imm' else [None]
    seen = []
    for i in imms:
        if i not in seen: seen.append(i)
    imms = seen
    L = ['@sink = global i32 0', '@av = global [%d x i64] [%s]' % (len(A), ', '.join('i64 %d' % v for v in A))]
    funcs = []
    for cc in CC:
        for i in imms:
            n = len(funcs)
            funcs.append((cc, i))
            rhs = str(i) if form == 'imm' else '%b'
            sig = '%s %%a' % ty if form == 'imm' else '%s %%a, %s %%b' % (ty, ty)
            if kind == 'setcc':
                L += ['define i32 @f%d(%s) noinline {' % (n, sig), '  %%c = icmp %s %s %%a, %s' % (cc, ty, rhs), '  %r = zext i1 %c to i32', '  ret i32 %r', '}']
            elif kind == 'select':
                L += ['define i32 @f%d(%s, i32 %%x, i32 %%y) noinline {' % (n, sig), '  %%c = icmp %s %s %%a, %s' % (cc, ty, rhs), '  %r = select i1 %c, i32 %x, i32 %y', '  ret i32 %r', '}']
            else:
                L += ['define i32 @f%d(%s) noinline {' % (n, sig), '  %%c = icmp %s %s %%a, %s' % (cc, ty, rhs), '  br i1 %c, label %t, label %f', 't:',
                      '  store volatile i32 1, ptr @sink', '  br label %m', 'f:', '  store volatile i32 0, ptr @sink', '  br label %m', 'm:', '  %r = load volatile i32, ptr @sink', '  ret i32 %r', '}']
    # driver: loop over the values of A (and B = A for the register form), calling every function
    L += ['define i32 @test() {', 'entry:', '  br label %oi', 'oi:', '  %i = phi i64 [0, %entry], [%in, %ol]', '  %acc0 = phi i32 [0, %entry], [%accj, %ol]']
    if form == 'reg':
        L += ['  br label %il', 'il:', '  %j = phi i64 [0, %oi], [%jn, %il]', '  %acc1 = phi i32 [%acc0, %oi], [%accn, %il]']
        L += ['  %pb = getelementptr i64, ptr @av, i64 %j', '  %b64 = load i64, ptr %pb']
        acc = '%acc1'
    else:
        acc = '%acc0'
    L += ['  %pa = getelementptr i64, ptr @av, i64 %i', '  %a64 = load i64, ptr %pa']
    if bits == 32:
        L += ['  %a = trunc i64 %a64 to i32']
        if form == 'reg': L += ['  %b = trunc i64 %b64 to i32']
    else:
        L += ['  %a = add i64 %a64, 0']
        if form == 'reg': L += ['  %b = add i64 %b64, 0']
    for n, (cc, i) in enumerate(funcs):
        args = '%s %%a' % ty + (', %s %%b' % ty if form == 'reg' else '')
        if kind == 'select': args += ', i32 3, i32 5'
        L.append('  %%r%d = call i32 @f%d(%s)' % (n, n, args))
        L.append('  %%m%d = mul i32 %s, 31' % (n, acc))
        L.append('  %%h%d = add i32 %%m%d, %%r%d' % (n, n, n))
        acc = '%%h%d' % n
    if form == 'reg':
        L += ['  %%accn = add i32 %s, 0' % acc, '  %jn = add i64 %j, 1', '  %%jd = icmp eq i64 %%jn, %d' % len(A), '  br i1 %jd, label %ol, label %il', 'ol:', '  %accj = add i32 %accn, 0']
    else:
        L += ['  %%accj = add i32 %s, 0' % acc, '  br label %ol', 'ol:']
    L += ['  %in = add i64 %i, 1', '  %%id = icmp eq i64 %%in, %d' % len(A), '  br i1 %id, label %done, label %oi', 'done:', '  ret i32 %accj', '}']
    acc = 0
    for a in A:
        for b in (A if form == 'reg' else [None]):
            for (cc, i) in funcs:
                bb = b if form == 'reg' else i
                m = model(cc, a, bb, bits)
                r = (1 if m else 0) if kind != 'select' else (3 if m else 5)
                acc = wrap32(acc * 31 + r)
    return acc, '\n'.join(L) + '\n'


for kind in ('setcc', 'select', 'branch'):
    for form in ('imm', 'reg'):
        for bits in (64, 32):
            if form == 'reg' and bits == 32 and kind != 'setcc': continue
            exp, body = gen(kind, form, bits)
            what = {'setcc': 'as a value (setCC)', 'select': 'as the condition of a select', 'branch': 'as a branch (cbCC)'}[kind]
            hdr = '; expect: %d  -- every integer condition on i%d against %s %s; operands around the edges of the immediate fields\n' % (exp, bits, 'constants' if form == 'imm' else 'a register', what)
            hdr += '; noasm: ^[[:space:]]+(cmp|tst|bit|adc|sbc|set|fcmp|fcmp32|b(ne|eq|pl|mi|vc|vs|cc|cs|ge|lt|gt|le|hi|los|hos|lo)|bhis)[[:space:]]\n'
            if kind == 'setcc': hdr += '; asm: ^[[:space:]]+set(eq|ne|lt|le|gt|ge|cs|cc|hi|los)[[:space:]]\n'
            with open(os.path.join(HERE, 'icmp_%s_%s%d.ll' % (kind, form, bits)), 'w') as f:
                f.write(hdr + body)
