# n=5 model=out iset=I1 prefix14_class=3118
mov S0, P2
cmp P3, P0
cmovl S1, P3
cmovge S1, P0
cmovge P0, P3
cmp P1, P2
cmovle P2, P1
cmovg S0, P1
mov S2, S1
cmp S1, P2
cmovl S2, P2
mov P3, S2
cmovge S1, P2
mov P2, S0
