# n=5 model=out iset=I1 prefix14_class=8305
mov S1, P0
cmp P2, S1
cmovle P0, P2
cmovg S1, P2
cmp P1, P3
mov S0, P0
cmovge S2, P1
cmovl S2, P3
cmovg P1, P3
cmp P0, P1
cmovle P0, P1
cmovge S0, P1
cmp S1, S2
cmovg P1, P0
