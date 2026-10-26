# n=5 model=out iset=I1 prefix14_class=5633
mov S2, P1
cmp P1, P3
cmovge P1, P3
mov S0, P1
cmovl S2, P3
cmp P0, P2
mov S1, P0
cmovl S1, P2
cmovle P2, P0
cmp S0, P2
cmovg P1, P2
cmovge P2, S0
cmp S1, S2
cmovge S0, S1
