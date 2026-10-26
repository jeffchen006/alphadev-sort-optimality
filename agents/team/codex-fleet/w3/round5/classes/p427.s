# n=5 model=out iset=I1 prefix14_class=427
cmp P3, P0
cmovge S1, P3
mov S0, P2
cmovl S1, P0
cmovl P0, P3
cmp S0, P1
cmovg P2, P1
cmovge P1, S0
cmovge S0, P2
cmp P0, P2
cmovle S0, P0
cmovle P0, P2
cmp P1, S1
cmovl P2, P1
