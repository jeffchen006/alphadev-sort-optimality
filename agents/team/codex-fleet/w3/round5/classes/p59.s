# n=5 model=out iset=I1 prefix14_class=59
mov S1, P2
cmp P1, S1
cmovl S1, P1
cmovle P1, P2
mov S2, P3
cmp P0, S2
cmovg P3, P0
mov P2, P3
cmovle S2, P0
mov S0, S1
cmp S0, S2
cmovge S0, S2
cmovge S2, S1
cmovl S1, S2
