# n=5 model=out iset=I1 prefix14_class=2436
mov S2, P1
cmp P2, P0
cmovle S0, P2
cmovl P2, P0
cmovge S0, P0
cmp P1, P3
cmovl S2, P3
cmovl P3, P1
cmp S2, P2
cmovle P1, P2
cmovl P2, S2
cmovge P1, S2
cmp P3, S0
cmovg S2, P2
