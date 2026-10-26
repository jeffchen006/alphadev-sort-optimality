# n=5 model=out iset=I1 prefix14_class=13126
mov S0, P2
cmp P2, P1
cmovl S0, P1
mov S2, P3
mov S1, S0
cmovle P1, P2
cmp S2, P0
cmovg P3, P0
cmovl S2, P0
cmp P1, P3
cmovge P2, P1
cmovg P1, P3
cmovg P3, P2
cmp S1, S2
