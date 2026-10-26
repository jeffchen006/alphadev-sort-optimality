# n=5 model=out iset=I1 prefix14_class=4030
mov S2, P0
cmp P2, P1
cmovge S1, P2
cmovg P2, P1
cmovge P1, S1
cmp P3, P0
cmovge S2, P3
cmovle P0, P3
mov P3, P0
cmp P2, P0
cmovl P0, P2
cmovg P3, P2
cmp S2, P1
cmovge S0, P1
