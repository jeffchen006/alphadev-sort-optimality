# n=5 model=out iset=I1 prefix14_class=2370
cmp P0, P3
mov S0, P0
mov S2, P1
cmovl P0, P3
cmovg S0, P3
cmp P2, S2
cmovle P1, P2
cmovge S2, P2
mov P2, S2
cmp P0, S2
cmovge P2, P0
cmovl S2, P0
mov S1, S0
mov P0, S2
