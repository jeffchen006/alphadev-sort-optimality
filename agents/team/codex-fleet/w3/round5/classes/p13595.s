# n=5 model=out iset=I1 prefix14_class=13595
mov S0, P2
cmp P3, P1
mov S1, P1
cmovge S1, P3
cmovle P1, P3
cmp P0, S0
cmovl P2, P0
cmovl P0, S0
cmp P2, P1
cmovle S0, P1
cmovl P1, P2
mov S2, P0
cmovl P2, S0
mov P1, P2
