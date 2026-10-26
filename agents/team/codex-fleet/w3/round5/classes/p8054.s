# n=5 model=out iset=I1 prefix14_class=8054
mov S2, P2
cmp P3, P2
cmovle S2, P3
mov S0, S2
cmovle P3, P2
mov S1, P1
cmp S1, P0
cmovge S1, P0
cmovg P0, P1
cmp S0, S1
cmovl S2, S1
cmovge S0, S1
cmp P0, P3
cmovg P2, P0
