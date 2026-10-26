# n=5 model=out iset=I1 prefix14_class=2395
cmp P0, P2
cmovle S2, P2
cmovge S2, P0
cmovg P0, P2
cmovg P2, S2
cmp P3, P1
cmovle S0, P3
cmovl P3, P1
cmovl P1, S0
cmp P2, P3
cmovl S2, P3
cmovle P3, P2
mov S2, P1
cmp P1, P0
