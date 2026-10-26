# n=5 model=out iset=I1 prefix14_class=3470
mov S0, P0
cmp P3, P2
mov S1, P2
cmovge S1, P3
cmovg P3, P2
cmp P0, P1
cmovg P0, P1
cmovl S0, P1
cmovle P1, P0
cmp P3, P1
cmovg P0, P3
cmovge P3, P1
cmp S0, S1
cmovle P1, S1
