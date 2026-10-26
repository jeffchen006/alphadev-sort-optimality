# n=5 model=out iset=I1 prefix14_class=4192
cmp P0, P1
cmovge S2, P0
cmovge P0, P1
cmovle S2, P1
cmp P2, P3
cmovle S0, P2
cmovl P2, P3
cmovle P3, S0
cmp P3, P0
mov S1, P3
cmovl S1, P0
cmovle P0, P3
mov P3, S2
cmp S2, P2
