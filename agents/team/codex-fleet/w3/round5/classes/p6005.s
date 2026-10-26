# n=5 model=out iset=I1 prefix14_class=6005
mov S1, P3
mov S2, P1
cmp S1, P0
cmovg P3, P0
cmovle S1, P0
cmp P2, P1
cmovle P1, P2
cmovge S2, P2
mov S0, S2
cmp S1, S0
cmovge S2, S1
mov S2, P1
cmovl S0, S1
cmovge S1, S0
