# n=5 model=out iset=I1 prefix14_class=1937
mov S0, P3
cmp P1, P3
mov S2, P2
cmovle S0, P1
cmovle P1, P3
cmp P0, P2
cmovl P2, P0
cmovle P0, S2
cmp P0, P1
cmovge S2, P1
cmovl S2, P0
cmovge P1, P0
cmp S0, P2
cmovl S1, P2
