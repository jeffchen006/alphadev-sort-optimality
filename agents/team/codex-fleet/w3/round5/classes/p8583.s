# n=5 model=out iset=I1 prefix14_class=8583
cmp P1, P2
mov S1, P0
mov S2, P1
cmovle P1, P2
cmovl P2, S2
cmp S1, P3
cmovge S1, P3
mov S0, P1
cmovl P0, P3
cmp P1, P0
cmovge S0, P0
cmovl P1, P0
cmp P2, S1
cmovge P1, S1
