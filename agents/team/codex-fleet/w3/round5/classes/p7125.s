# n=5 model=out iset=I1 prefix14_class=7125
mov S0, P3
cmp P1, S0
cmovl P3, P1
cmovl P1, S0
mov S1, P0
cmp S1, P2
cmovge S1, P2
cmovle P0, P2
cmp P3, S1
cmovge P2, P3
cmovle P2, S1
cmovle S1, P3
cmp P0, P1
cmovl S2, P1
