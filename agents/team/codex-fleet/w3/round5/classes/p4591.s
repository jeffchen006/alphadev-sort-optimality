# n=5 model=out iset=I1 prefix14_class=4591
mov S1, P3
cmp P1, P3
cmovg S1, P1
cmovle P3, P1
mov S2, S1
cmp P0, P2
cmovle S0, P2
cmovle P2, P0
cmovl P0, S0
cmp P0, S1
cmovl S1, P0
cmovge S2, P0
cmp P3, P2
mov P1, P2
