# n=5 model=out iset=I1 prefix14_class=12214
cmp P1, P0
cmovle S1, P1
mov S2, P2
cmovl P1, P0
cmovle P0, S1
cmp P3, P2
cmovl S2, P3
cmovle P3, P2
cmp P0, S2
cmovl S0, P0
cmovge S0, S2
cmovg S2, P0
mov S0, P1
cmp P1, P3
