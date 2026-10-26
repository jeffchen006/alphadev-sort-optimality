# n=5 model=out iset=I1 prefix14_class=5009
mov S2, P3
mov S0, P1
cmp P1, P0
cmovl P1, P0
cmovle P0, S0
cmp P2, S2
cmovge S2, P2
cmovl P3, P2
cmp P3, P0
cmovle S0, P0
cmovl P0, P3
cmovl P3, S0
mov P0, S2
cmp P0, P1
