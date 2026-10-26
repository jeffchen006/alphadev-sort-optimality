# n=5 model=out iset=I1 prefix14_class=6493
mov S1, P0
cmp P2, P0
cmovle P0, P2
cmovg S1, P2
cmp P3, P1
cmovle S0, P1
cmovl P1, P3
cmovge S0, P3
cmp S0, S1
cmovl P2, S1
cmovle S1, S0
mov P3, S1
cmovl S0, P2
cmp P0, P1
