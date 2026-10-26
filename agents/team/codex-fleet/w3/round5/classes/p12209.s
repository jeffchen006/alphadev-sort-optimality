# n=5 model=out iset=I1 prefix14_class=12209
cmp P0, P1
cmovl S2, P0
cmovl P0, P1
cmovl P1, S2
cmp P3, P2
cmovge S0, P2
cmovle S0, P3
cmovle P3, P2
cmp P1, S0
mov S1, P1
cmovg S1, S0
cmovg S0, P1
mov P1, P3
mov S1, S0
