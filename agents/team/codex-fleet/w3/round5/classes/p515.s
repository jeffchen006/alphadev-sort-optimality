# n=5 model=out iset=I1 prefix14_class=515
cmp P3, P0
cmovge S0, P0
cmovl S0, P3
cmovg P0, P3
mov S2, P2
cmp P2, P1
cmovg S2, P1
cmovge P1, P2
mov S1, P0
cmp S2, S0
cmovle P2, S0
cmovl S0, S2
cmovle S2, P2
cmp S1, P1
