# n=5 model=out iset=I1 prefix14_class=9225
cmp P3, P1
cmovle S0, P3
cmovge S0, P1
cmovg P1, P3
mov S2, S0
cmp P0, P2
cmovle S1, P2
cmovle P2, P0
cmovge S1, P0
cmp S0, P2
cmovl S2, P2
cmovge S0, P2
cmp S1, P1
cmovge S0, S1
