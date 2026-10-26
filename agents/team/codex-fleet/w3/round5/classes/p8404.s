# n=5 model=out iset=I1 prefix14_class=8404
mov S0, P1
cmp P1, P2
cmovge S0, P2
mov S2, P3
cmovg P2, P1
cmp P0, P3
cmovle P3, P0
cmovge S2, P0
cmovle P0, S2
cmp P0, P2
cmovl S2, P2
cmovg P0, P2
cmp P3, S0
cmovg P1, P3
