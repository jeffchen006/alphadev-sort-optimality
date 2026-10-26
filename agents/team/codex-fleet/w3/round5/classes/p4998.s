# n=5 model=out iset=I1 prefix14_class=4998
mov S2, P2
cmp P1, P3
cmovl S0, P3
cmovl P3, P1
cmovge S0, P1
mov P1, S0
cmp P0, P2
cmovle S2, P0
cmovg P2, P0
cmp S2, P3
cmovle P0, P3
cmovle P3, S2
cmovle S2, P0
cmp S0, P2
