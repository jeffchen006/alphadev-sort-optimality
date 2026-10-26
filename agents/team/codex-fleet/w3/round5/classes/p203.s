# n=5 model=out iset=I1 prefix14_class=203
cmp P3, P2
mov S2, P3
cmovle P3, P2
mov S1, P0
cmovle P2, S2
cmp P0, P1
cmovge S1, P1
cmovge P1, P0
cmp S1, P2
cmovle S0, S1
mov S2, P1
cmovl S1, P2
cmovl P2, S0
cmp S2, P3
