# n=5 model=out iset=I1 prefix14_class=11765
mov S2, P2
cmp P2, P0
cmovge S2, P0
cmovge P0, P2
cmp P3, P1
mov S1, P0
cmovl S0, P3
cmovle P3, P1
cmovl P1, S0
cmp P3, P0
cmovge S1, P3
cmovge P3, P0
cmp S2, P1
mov P0, S2
