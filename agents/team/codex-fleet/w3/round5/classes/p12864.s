# n=5 model=out iset=I1 prefix14_class=12864
mov S2, P3
cmp P0, P1
cmovle S0, P1
cmovle P1, P0
cmovl P0, S0
cmp P2, S2
cmovl S2, P2
cmovl P2, P3
cmp P1, S2
mov P3, P1
cmovge P3, S2
cmovle P1, S2
cmp P0, P2
cmovge S0, P0
