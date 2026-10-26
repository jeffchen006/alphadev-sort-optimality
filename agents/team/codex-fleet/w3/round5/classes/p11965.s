# n=5 model=out iset=I1 prefix14_class=11965
mov S2, P1
cmp P0, P1
cmovge S2, P0
cmovle P1, P0
cmp P3, P2
mov S1, S2
cmovg P0, P3
cmovg P3, P2
cmovg P2, P0
cmp S2, P2
mov S0, P3
cmovl S2, P2
cmovge S1, P2
cmp P3, P1
