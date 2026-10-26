# n=5 model=out iset=I1 prefix14_class=10633
cmp P0, P3
cmovl S0, P0
cmovl P0, P3
cmovge S0, P3
mov S2, P1
cmp S2, P2
cmovge P1, P2
cmovle S2, P2
cmp S2, P0
cmovle P2, S2
cmovl S2, P0
cmovle P0, P2
cmp P1, S0
cmovg P2, P0
