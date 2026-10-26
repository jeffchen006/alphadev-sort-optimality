# n=5 model=out iset=I1 prefix14_class=1160
cmp P3, P0
mov S0, P3
cmovle P3, P0
cmovl P0, S0
cmp P2, P1
cmovl S2, P2
cmovle P2, P1
cmovge S2, P1
mov S1, P2
cmp P2, P3
cmovle S1, P3
cmovge P2, P3
cmovl P3, P2
cmp S2, P0
