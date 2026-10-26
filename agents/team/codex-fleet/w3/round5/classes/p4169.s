# n=5 model=out iset=I1 prefix14_class=4169
mov S2, P1
cmp P0, P2
mov S1, P2
cmovle S1, P0
cmovg P2, P0
cmp S2, P3
cmovle P1, P3
mov S0, S1
cmovle P3, S2
cmp P3, S0
cmovl S1, P3
cmovge S0, P3
mov P3, P2
mov S1, S0
