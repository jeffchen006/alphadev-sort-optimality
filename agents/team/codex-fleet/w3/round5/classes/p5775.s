# n=5 model=out iset=I1 prefix14_class=5775
mov S1, P1
mov S2, P3
cmp S1, P2
cmovge P1, P2
cmovl S1, P2
cmp P0, S2
cmovg P3, P0
mov S0, P1
cmovl S2, P0
cmp S2, P1
cmovl S0, S2
cmovg P1, S2
cmp S1, P3
cmovle P0, S1
