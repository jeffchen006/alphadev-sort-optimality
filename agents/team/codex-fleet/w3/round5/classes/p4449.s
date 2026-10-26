# n=5 model=out iset=I1 prefix14_class=4449
mov S2, P3
cmp P2, P3
cmovg P3, P2
cmovg P2, S2
cmp P1, P0
cmovl S2, P0
cmovge S2, P1
cmovl P0, P1
mov S0, S2
cmp S0, P3
cmovle S2, P3
cmovle P3, S0
cmp P0, P2
cmovle P1, P0
