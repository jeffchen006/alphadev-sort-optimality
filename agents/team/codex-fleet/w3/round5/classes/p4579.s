# n=5 model=out iset=I1 prefix14_class=4579
mov S2, P0
cmp P1, P2
cmovge S0, P1
cmovle S0, P2
cmovl P2, P1
mov S1, S0
cmp P0, P3
cmovle P0, P3
cmovg S2, P3
cmp S0, P0
cmovl S0, P0
mov S0, P2
cmovg S1, P0
cmp S2, S0
