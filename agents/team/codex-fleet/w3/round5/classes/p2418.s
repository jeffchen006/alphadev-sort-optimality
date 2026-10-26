# n=5 model=out iset=I1 prefix14_class=2418
mov S1, P3
cmp P3, P0
cmovge P3, P0
mov S2, P2
cmovge P0, S1
cmp P1, P2
mov S0, P0
cmovl P2, P1
cmovg S2, P1
cmp S0, S2
cmovg P0, S2
cmovl S0, S2
cmp P2, P3
cmovle S2, P3
