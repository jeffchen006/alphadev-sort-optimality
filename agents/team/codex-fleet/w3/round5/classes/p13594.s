# n=5 model=out iset=I1 prefix14_class=13594
mov S0, P2
cmp P0, P1
mov S1, P1
cmovge S1, P0
cmovl P1, P0
cmp P3, S0
cmovl P2, P3
cmovl P3, S0
cmp P2, P1
cmovle S0, P1
cmovle P1, P2
mov S2, P3
cmovl P2, S0
mov P1, P2
