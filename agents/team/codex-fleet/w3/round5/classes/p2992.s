# n=5 model=out iset=I1 prefix14_class=2992
mov S1, P2
cmp P1, P2
cmovl P2, P1
cmovge S1, P1
cmp P3, P0
cmovg S2, P3
cmovge P3, P0
mov S0, S1
cmovg P0, S2
mov P1, P2
cmp S0, P0
cmovg S1, P0
cmovg P0, S0
cmp P2, P3
