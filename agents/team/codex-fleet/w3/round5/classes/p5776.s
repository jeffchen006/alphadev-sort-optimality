# n=5 model=out iset=I1 prefix14_class=5776
mov S1, P1
cmp S1, P3
mov S2, P2
cmovge P1, P3
cmovl S1, P3
cmp P0, S2
cmovg P2, P0
mov S0, P1
cmovl S2, P0
cmp S2, P1
cmovl S0, S2
cmovg P1, S2
cmp S1, P2
cmovle P0, S1
