# n=5 model=out iset=I1 prefix14_class=6173
cmp P2, P0
cmovl S0, P2
cmovge S0, P0
cmovl P2, P0
cmp P3, P1
cmovg S2, P3
cmovle S2, P1
cmovle P1, P3
cmp S2, P2
mov S1, P2
cmovg P2, S2
cmovge S2, S1
cmp S0, P1
cmovge S1, P1
