# n=5 model=out iset=I1 prefix14_class=3952
mov S0, P0
cmp S0, P1
cmovg P0, P1
cmovl S0, P1
cmp P2, P3
mov P1, P0
cmovge S2, P2
cmovle S2, P3
cmovle P3, P2
cmp P3, P1
cmovg P0, P3
cmovl P1, P3
cmp S0, S2
mov P1, S0
