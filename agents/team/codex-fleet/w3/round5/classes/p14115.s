# n=5 model=out iset=I1 prefix14_class=14115
mov S2, P2
mov S0, P1
cmp P0, S2
cmovl P2, P0
cmovl P0, S2
cmp P3, S0
cmovle P1, P3
cmovge S0, P3
cmp P0, S0
cmovle S2, P0
mov S1, P1
cmovl P0, S0
cmovle S0, S2
mov P0, S0
