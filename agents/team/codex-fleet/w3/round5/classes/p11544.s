# n=5 model=out iset=I1 prefix14_class=11544
mov S2, P1
cmp P0, P2
cmovl S0, P2
cmovl P2, P0
cmovl P0, S0
cmp S2, P3
cmovle P1, P3
cmovle P3, S2
cmp P3, P2
cmovge S1, P3
cmovge P3, P2
cmovle S1, P2
cmp P0, P1
cmovge P2, P0
