# n=5 model=out iset=I1 prefix14_class=64
mov S0, P0
cmp P1, P3
mov S1, P1
cmovl P1, P3
cmovge S1, P3
cmp P2, P0
cmovle P0, P2
cmovg S0, P2
mov P2, P0
cmp P0, S1
mov S2, P1
cmovge P2, S1
cmovg S1, P0
cmp S2, S0
