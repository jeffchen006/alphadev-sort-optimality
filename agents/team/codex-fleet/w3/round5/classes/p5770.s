# n=5 model=out iset=I1 prefix14_class=5770
cmp P1, P0
mov S2, P2
cmovge S1, P0
cmovg P0, P1
cmovge P1, S1
mov S0, P1
cmp P3, P2
cmovg S2, P3
cmovl P2, P3
cmp P2, S0
cmovge S0, P2
cmovle P1, P2
mov P1, S2
cmp S2, P0
