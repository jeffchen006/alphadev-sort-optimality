# n=5 model=out iset=I1 prefix14_class=2235
cmp P3, P1
mov S1, P1
cmovg P1, P3
cmovg P3, S1
cmp P2, P0
cmovle S1, P0
cmovg S1, P2
cmovg P2, P0
mov S2, P1
cmp P1, S1
cmovl P1, S1
cmovle S1, S2
cmp P3, P2
cmovl P1, P3
