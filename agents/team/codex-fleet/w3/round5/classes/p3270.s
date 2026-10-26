# n=5 model=out iset=I1 prefix14_class=3270
cmp P1, P0
cmovg S0, P1
cmovg P1, P0
mov S1, P3
cmovg P0, S0
cmp P2, S1
mov S2, P1
cmovg S1, P2
cmovg P2, P3
cmp S2, P2
mov P3, P0
cmovg P1, P2
cmovle S2, P2
cmp P3, S1
