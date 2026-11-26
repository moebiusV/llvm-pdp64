#!/usr/bin/env python3
"""gen_fcmp.py -- writes tests/fcmp_*.ll: every floating-point compare predicate (oeq one ogt oge olt ole ueq une ugt uge ult ule ord uno) of double and float,
on all pairs of 0.0, -0.0, 1.0, -1.0, 2.5, -2.5, +inf, -inf and a NaN, used as a branch, as a select of integers, as a select of floating-point values and as a zext of the compare.
The machine has no flags: the compares are fcbCC (compare and branch; no "not less than", so the unordered-or-X predicates are an fcbuo and an fcbX, or a negated branch with the
arms swapped).  The expected value of each (the first line, `; expect: N`) is computed here by a model of the predicates, not by llc.
    python3 tests/gen_fcmp.py"""
import os, struct, math
HERE = os.path.dirname(os.path.abspath(__file__))
PRED = ['oeq', 'one', 'ogt', 'oge', 'olt', 'ole', 'ueq', 'une', 'ugt', 'uge', 'ult', 'ule', 'ord', 'uno']
NAN = float('nan')
VALS = [0.0, -0.0, 1.0, -1.0, 2.5, -2.5, math.inf, -math.inf, NAN]


def model(p, a, b):
    un = math.isnan(a) or math.isnan(b)
    if p == 'ord': return not un
    if p == 'uno': return un
    o, u = p[0] == 'o', p[0] == 'u'
    if un: return u
    r = p[1:]
    return {'eq': a == b, 'ne': a != b, 'gt': a > b, 'ge': a >= b, 'lt': a < b, 'le': a <= b}[r]


def wrap32(v):
    v &= 0xffffffff
    return v - (1 << 32) if v >> 31 else v


def lit(v, ty):
    if ty == 'float':
        v = struct.unpack('<f', struct.pack('<f', v))[0]
    return '0x%016X' % struct.unpack('<Q', struct.pack('<d', v))[0]


def bits(v, ty):
    if ty == 'float':
        return struct.unpack('<I', struct.pack('<f', v))[0]
    q = struct.unpack('<Q', struct.pack('<d', v))[0]
    return (q & 0xffffffff) ^ (q >> 32)


def gen(kind, ty):
    I = 'i32'
    L = []
    L.append('@sink = global i32 0')
    L.append('@vals = global [%d x %s] [%s]' % (len(VALS), ty, ', '.join('%s %s' % (ty, lit(v, ty)) for v in VALS)))
    for k, p in enumerate(PRED):
        if kind == 'branch':
            L += ['define i32 @p%d(%s %%a, %s %%b) noinline {' % (k, ty, ty), '  %%c = fcmp %s %s %%a, %%b' % (p, ty),
                  '  br i1 %c, label %t, label %f', 't:', '  store volatile i32 1, ptr @sink', '  br label %m', 'f:', '  store volatile i32 0, ptr @sink',
                  '  br label %m', 'm:', '  %r = load volatile i32, ptr @sink', '  ret i32 %r', '}']
        elif kind == 'select':
            L += ['define i32 @p%d(%s %%a, %s %%b, i32 %%x, i32 %%y) noinline {' % (k, ty, ty), '  %%c = fcmp %s %s %%a, %%b' % (p, ty),
                  '  %r = select i1 %c, i32 %x, i32 %y', '  ret i32 %r', '}']
        elif kind == 'zext':
            L += ['define i32 @p%d(%s %%a, %s %%b) noinline {' % (k, ty, ty), '  %%c = fcmp %s %s %%a, %%b' % (p, ty),
                  '  %r = zext i1 %c to i32', '  ret i32 %r', '}']
        elif kind == 'selectfp':
            ib = 'i32' if ty == 'float' else 'i64'
            L += ['define i32 @p%d(%s %%a, %s %%b) noinline {' % (k, ty, ty), '  %%c = fcmp %s %s %%a, %%b' % (p, ty),
                  '  %%r = select i1 %%c, %s %%a, %s %%b' % (ty, ty), '  %%q = bitcast %s %%r to %s' % (ty, ib)]
            if ty == 'float':
                L += ['  ret i32 %q']
            else:
                L += ['  %lo = trunc i64 %q to i32', '  %sh = lshr i64 %q, 32', '  %hi = trunc i64 %sh to i32', '  %x = xor i32 %lo, %hi', '  ret i32 %x']
            L += ['}']
        elif kind == 'selectcc':
            # the compare selects between two values that are not the operands (a float and a double of other values), so the arms are separate registers
            L += ['define i32 @p%d(%s %%a, %s %%b, %s %%x, %s %%y) noinline {' % (k, ty, ty, ty, ty), '  %%c = fcmp %s %s %%a, %%b' % (p, ty),
                  '  %%r = select i1 %%c, %s %%x, %s %%y' % (ty, ty), '  %%t = fcmp ogt %s %%r, 0.0' % ty, '  %z = zext i1 %t to i32', '  ret i32 %z', '}']
    L += ['define i32 @test() {', 'entry:', '  br label %oi', 'oi:', '  %i = phi i64 [0, %entry], [%in, %ol]', '  %acc0 = phi i32 [0, %entry], [%accj, %ol]',
          '  br label %il', 'il:', '  %j = phi i64 [0, %oi], [%jn, %il]', '  %acc1 = phi i32 [%acc0, %oi], [%accn, %il]',
          '  %%pa = getelementptr %s, ptr @vals, i64 %%i' % ty, '  %%pb = getelementptr %s, ptr @vals, i64 %%j' % ty,
          '  %%a = load %s, ptr %%pa' % ty, '  %%b = load %s, ptr %%pb' % ty]
    acc = '%acc1'
    for k in range(len(PRED)):
        if kind == 'select':
            L.append('  %%r%d = call i32 @p%d(%s %%a, %s %%b, i32 3, i32 5)' % (k, k, ty, ty))
        elif kind == 'selectcc':
            L.append('  %%r%d = call i32 @p%d(%s %%a, %s %%b, %s 1.0, %s -1.0)' % (k, k, ty, ty, ty, ty))
        else:
            L.append('  %%r%d = call i32 @p%d(%s %%a, %s %%b)' % (k, k, ty, ty))
        L.append('  %%m%d = mul i32 %s, 31' % (k, acc))
        L.append('  %%h%d = add i32 %%m%d, %%r%d' % (k, k, k))
        acc = '%%h%d' % k
    L += ['  %%accn = add i32 %s, 0' % acc, '  %jn = add i64 %j, 1', '  %%jd = icmp eq i64 %%jn, %d' % len(VALS), '  br i1 %jd, label %ol, label %il', 'ol:',
          '  %accj = add i32 %accn, 0', '  %in = add i64 %i, 1', '  %%id = icmp eq i64 %%in, %d' % len(VALS), '  br i1 %id, label %done, label %oi', 'done:', '  ret i32 %accj', '}']
    # model
    acc = 0
    for a in VALS:
        for b in VALS:
            for p in PRED:
                if kind in ('branch', 'zext'): r = int(model(p, a, b))
                elif kind == 'select': r = 3 if model(p, a, b) else 5
                elif kind == 'selectfp': r = bits(a if model(p, a, b) else b, ty)
                elif kind == 'selectcc':
                    r = 1 if (1.0 if model(p, a, b) else -1.0) > 0 else 0
                acc = wrap32(acc * 31 + wrap32(r))
    # the loops above visit i (outer) and j (inner) in the same order as the model
    return acc, '\n'.join(L) + '\n'


for kind in ('branch', 'select', 'zext', 'selectfp', 'selectcc'):
    for ty in ('double', 'float'):
        exp, body = gen(kind, ty)
        what = {'branch': 'as a branch', 'select': 'as the condition of a select of integers', 'zext': 'as a zext to an integer', 'selectfp': 'as the condition of a select of %s values' % ty,
                'selectcc': 'as the condition of a select of other %s values' % ty}[kind]
        hdr = '; expect: %d  -- every floating-point predicate on %s operands (zeros of both signs, +-1, +-2.5, +-inf, NaN) %s; the machine has no flags: fcbCC and setless value sequences\n' % (exp, ty, what)
        hdr += '; noasm: ^[[:space:]]+(cmp|tst|bit|adc|sbc|set|fcmp|fcmp32|b(ne|eq|pl|mi|vc|vs|cc|cs|ge|lt|gt|le|hi|los|hos|lo)|bhis)[[:space:]]\n'
        hdr += '; asm: ^[[:space:]]+fcb(eq|ne|lt|le|uo|or)%s[[:space:]]\n' % ('32' if ty == 'float' else '')
        with open(os.path.join(HERE, 'fcmp_%s_%s.ll' % (kind, ty)), 'w') as f:
            f.write(hdr + body)
