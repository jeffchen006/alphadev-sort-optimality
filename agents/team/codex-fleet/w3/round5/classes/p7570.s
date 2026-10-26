# n=5 model=out iset=I1 prefix14_class=7570
cmp P0, P2
cmovge S0, P2
cmovg P2, P0
cmovl S0, P0
mov S1, P3
cmp P3, P1
cmovge P3, P1
cmovl S1, P1
cmp P3, S0
cmovle P1, P3
cmovle P3, S0
cmovle S0, P1
cmp S1, P2
cmovl S2, S1
