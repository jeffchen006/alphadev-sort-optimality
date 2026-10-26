# n=5 model=out iset=I1 prefix14_class=4290
mov S0, P1
cmp S0, P0
cmovg S0, P0
cmovl P1, P0
cmp P2, P3
mov S2, P2
cmovge S2, P3
cmovl P2, P3
mov P3, S0
cmp S0, S2
cmovle P3, S2
cmovle S2, S0
cmp P2, P1
cmovl S2, P1
