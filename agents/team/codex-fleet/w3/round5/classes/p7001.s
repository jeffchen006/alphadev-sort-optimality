# n=5 model=out iset=I1 prefix14_class=7001
cmp P0, P3
mov S1, P1
cmovle S2, P3
cmovl P3, P0
cmovle P0, S2
cmp S1, P2
mov S0, P3
cmovle P1, P2
cmovl P2, S1
mov S1, P0
cmp S0, P2
cmovge P3, P2
cmovl S0, P2
cmp P0, P1
