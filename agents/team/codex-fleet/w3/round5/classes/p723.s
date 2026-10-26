# n=5 model=out iset=I1 prefix14_class=723
cmp P0, P2
cmovl S0, P0
mov S2, P1
cmovge S0, P2
cmovle P0, P2
cmp S2, P3
cmovg P1, P3
cmovle S2, P3
cmp P0, S2
cmovle S1, P0
cmovl P0, S2
cmovle S2, S1
cmp S0, P1
cmovge P0, S0
