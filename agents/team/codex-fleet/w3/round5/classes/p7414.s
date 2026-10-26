# n=5 model=out iset=I1 prefix14_class=7414
cmp P3, P2
mov S2, P2
cmovg P2, P3
cmovg P3, S2
mov S1, P0
cmp P0, P1
cmovg S1, P1
cmovg P1, P0
cmp S1, P3
mov S0, S1
cmovle S0, P3
cmovg S1, P3
cmp P1, P2
cmovle S2, P2
