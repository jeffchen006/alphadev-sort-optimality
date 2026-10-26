# n=5 model=out iset=I1 prefix14_class=13786
cmp P1, P3
cmovge S0, P1
mov S2, P2
cmovg P1, P3
cmovg P3, S0
cmp S2, P0
cmovg P2, P0
cmovl S2, P0
cmovge P0, S2
cmp P3, S2
cmovl S2, P3
cmovg P0, P3
cmp P1, P2
cmovle S1, P2
