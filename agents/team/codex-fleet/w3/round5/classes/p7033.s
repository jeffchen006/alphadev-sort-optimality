# n=5 model=out iset=I1 prefix14_class=7033
cmp P2, P0
cmovge S2, P0
cmovg P0, P2
mov S0, P3
cmovge P2, S2
cmp S0, P1
cmovg P3, P1
cmovl S0, P1
cmp P3, P2
mov S1, P2
cmovle P2, P3
cmovle P3, S1
cmp S0, P0
cmovg S1, S0
