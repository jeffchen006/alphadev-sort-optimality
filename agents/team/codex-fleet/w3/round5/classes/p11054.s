# n=5 model=out iset=I1 prefix14_class=11054
mov S0, P2
mov S2, P0
cmp P1, S0
cmovl P2, P1
cmovge S0, P1
cmp P0, P3
cmovle P0, P3
cmovl P3, S2
mov S1, P3
cmp P0, S0
cmovle S2, P0
cmovl P0, S0
cmovl S0, S2
mov P1, S0
