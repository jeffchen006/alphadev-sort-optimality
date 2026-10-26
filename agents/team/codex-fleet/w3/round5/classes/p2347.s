# n=5 model=out iset=I1 prefix14_class=2347
cmp P1, P3
mov S1, P1
cmovl P1, P3
cmovl P3, S1
mov S0, P0
cmp S0, P2
cmovle S0, P2
cmovge P0, P2
cmp P1, S0
cmovg P2, S0
cmovge S0, P1
cmovle P2, P1
cmp P0, P3
cmovl S2, P3
