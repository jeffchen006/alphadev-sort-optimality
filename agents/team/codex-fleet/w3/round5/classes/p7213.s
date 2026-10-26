# n=5 model=out iset=I1 prefix14_class=7213
cmp P0, P1
cmovge S0, P0
mov S1, P2
cmovl S0, P1
cmovg P0, P1
cmp P3, P2
cmovle P2, P3
cmovge S1, P3
mov P1, P2
cmp P1, P0
cmovle P2, P0
cmovg P1, P0
cmp S1, S0
cmovle S2, S0
