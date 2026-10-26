# n=5 model=out iset=I1 prefix14_class=10334
mov S0, P3
cmp P0, P3
cmovg P3, P0
mov S2, P2
cmovl S0, P0
cmp S2, P1
cmovle P2, P1
cmovle P1, S2
cmp P3, P2
cmovge P0, P3
cmovge P3, P2
cmovge P2, P0
cmp P1, S0
cmovg P0, P1
