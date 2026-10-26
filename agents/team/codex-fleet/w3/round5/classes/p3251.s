# n=5 model=out iset=I1 prefix14_class=3251
mov S0, P0
cmp P1, S0
cmovl S0, P1
mov S2, P2
cmovg P0, P1
cmovg P1, S0
cmp P3, P2
cmovge S2, P3
cmovg P3, P2
cmp P1, P3
cmovle S0, P3
cmovge P1, P3
cmp S2, P0
cmovle P1, S2
