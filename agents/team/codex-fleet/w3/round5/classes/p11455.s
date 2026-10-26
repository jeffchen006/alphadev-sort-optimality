# n=5 model=out iset=I1 prefix14_class=11455
cmp P3, P2
mov S0, P2
cmovl S0, P3
cmovle P3, P2
cmp P0, P1
mov S2, S0
cmovg P2, P1
cmovg P1, P0
cmovg P0, P2
cmp P0, S2
cmovge S2, P0
cmovl S0, P0
mov S0, S2
cmp P1, P3
