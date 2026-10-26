# n=5 model=out iset=I1 prefix14_class=1400
mov S1, P1
mov S0, P3
cmp P2, P3
cmovle S0, P2
cmovl P2, P3
cmp P0, P1
cmovl P1, P0
cmovge S1, P0
mov S2, P2
cmp P2, S1
cmovle P2, S1
cmovl S1, S2
cmp S0, P1
cmovge P0, S0
