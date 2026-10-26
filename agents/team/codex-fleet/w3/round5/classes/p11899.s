# n=5 model=out iset=I1 prefix14_class=11899
mov S2, P3
cmp P0, P2
cmovle S1, P2
cmovle P2, P0
cmovge S1, P0
cmp P3, P1
cmovl S2, P1
mov S0, S1
cmovle P1, P3
cmp S0, S2
cmovge S1, S2
cmovg S2, S0
cmp P1, P2
cmovge S0, P2
