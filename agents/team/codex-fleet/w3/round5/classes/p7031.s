# n=5 model=out iset=I1 prefix14_class=7031
mov S2, P1
cmp P2, S2
cmovge S2, P2
cmovg P2, P1
mov S1, P0
mov S0, P2
cmp S1, P3
cmovl S1, P3
cmovg P0, P3
cmp P0, P2
cmovle S0, P0
cmovle P0, P2
cmp S1, S2
cmovl P3, S2
