# n=5 model=out iset=I1 prefix14_class=10855
cmp P2, P0
mov S2, P3
cmovle S0, P2
cmovle P2, P0
cmovge S0, P0
cmp P1, P3
cmovge P3, P1
cmovl S2, P1
cmp P3, P2
mov S1, S0
cmovle P0, P2
cmovl P2, P3
cmovl P3, P0
cmp S2, S1
