# n=5 model=out iset=I1 prefix14_class=11616
cmp P3, P1
cmovge S0, P1
cmovge P1, P3
cmovl S0, P3
mov S2, P2
cmp P0, P2
cmovg P2, P0
cmovg P0, S2
mov P3, P2
cmp P1, P2
cmovge P2, P1
cmovle P3, P1
cmp S0, P0
cmovge P1, P3
