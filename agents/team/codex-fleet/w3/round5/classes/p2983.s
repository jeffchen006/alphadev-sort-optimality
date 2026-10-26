# n=5 model=out iset=I1 prefix14_class=2983
cmp P2, P0
mov S0, P0
cmovle P0, P2
mov S1, P3
cmovge S0, P2
cmp P3, P1
cmovg P3, P1
cmovg P1, S1
cmp S0, P1
mov S2, P1
cmovl S2, S0
cmovg P1, S0
mov P1, S2
cmp P0, P3
