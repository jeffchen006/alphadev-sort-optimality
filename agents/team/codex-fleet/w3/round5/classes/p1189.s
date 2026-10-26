# n=5 model=out iset=I1 prefix14_class=1189
cmp P1, P2
cmovl S2, P1
cmovle P1, P2
cmovl P2, S2
cmp P0, P3
cmovg S1, P0
mov S2, P1
cmovg P0, P3
cmovle S1, P3
cmp S2, S1
mov S0, P0
cmovge S2, S1
cmovge S1, P1
cmp S0, P2
