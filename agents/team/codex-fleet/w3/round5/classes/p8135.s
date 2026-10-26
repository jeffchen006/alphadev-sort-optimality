# n=5 model=out iset=I1 prefix14_class=8135
cmp P3, P0
mov S2, P0
cmovg P0, P3
cmovle S2, P3
cmp P2, P1
cmovg P3, P1
cmovg P1, P2
mov S1, S2
cmovg P2, P3
cmp S1, P2
cmovle S1, P2
cmovg S2, P2
mov S0, P1
cmp S0, P0
