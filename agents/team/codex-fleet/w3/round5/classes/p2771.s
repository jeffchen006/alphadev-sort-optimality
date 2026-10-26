# n=5 model=out iset=I1 prefix14_class=2771
cmp P0, P2
cmovge S0, P0
cmovg P0, P2
cmovle S0, P2
cmp P3, P1
cmovle P2, P3
cmovg P2, P1
cmovle P3, P1
mov P1, P3
cmp S0, P3
cmovle P1, S0
cmovl S0, P3
cmp P0, P2
cmovl S2, P0
