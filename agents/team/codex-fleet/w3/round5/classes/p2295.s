# n=5 model=out iset=I1 prefix14_class=2295
cmp P2, P0
mov S0, P3
cmovle S2, P0
cmovge S2, P2
cmovge P2, P0
cmp P3, P1
cmovl S0, P1
cmovge P3, P1
cmp S0, S2
cmovle P1, S2
cmovl S2, S0
cmovg P1, S0
cmp P3, P2
mov P1, P3
