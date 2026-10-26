# n=5 model=out iset=I1 prefix14_class=1396
cmp P0, P3
mov S0, P0
mov S2, P2
cmovg S0, P3
cmovg P3, P0
cmp S2, P1
cmovg S2, P1
cmovge P1, P2
mov P0, P1
cmp P3, P1
cmovl P0, P3
cmovl P3, P1
cmovl P1, P0
mov S1, S2
