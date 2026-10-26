# n=5 model=out iset=I1 prefix14_class=13217
mov S2, P1
cmp P0, P3
cmovg S0, P3
cmovg P3, P0
cmovg P0, S0
cmp P1, P2
cmovge S2, P2
cmovle P1, P2
mov S1, P0
cmp S2, S1
cmovg P0, S2
cmovl S1, S2
cmp P1, P3
mov S1, P1
