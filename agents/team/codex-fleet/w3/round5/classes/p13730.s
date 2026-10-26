# n=5 model=out iset=I1 prefix14_class=13730
mov S2, P2
cmp P1, P3
cmovle S0, P3
cmovl P3, P1
cmovle P1, S0
cmp S2, P0
cmovg P2, P0
cmovl S2, P0
cmp S2, P1
cmovge P0, P1
mov S1, P2
cmovge P1, S2
cmovge S2, P0
cmp S1, P3
