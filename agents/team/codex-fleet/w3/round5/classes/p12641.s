# n=5 model=out iset=I1 prefix14_class=12641
mov S2, P0
cmp P1, S2
mov S1, P3
cmovge P0, P1
cmovle S2, P1
cmp P2, S1
cmovl S1, P2
cmovl P2, P3
cmp S2, S1
cmovle P3, S1
cmovle S1, S2
cmovle S2, P3
cmp P2, P0
cmovl S0, P2
