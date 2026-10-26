# n=5 model=out iset=I1 prefix14_class=5382
mov S0, P3
cmp P2, P1
cmovl S1, P1
cmovle P1, P2
cmovl P2, S1
cmp S0, P0
cmovl S0, P0
cmovg P3, P0
cmp P1, P3
mov S2, P3
cmovle S2, P1
cmovge P3, P1
cmp S0, P2
cmovge S1, P2
