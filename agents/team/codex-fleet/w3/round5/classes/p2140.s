# n=5 model=out iset=I1 prefix14_class=2140
cmp P0, P2
cmovge S0, P2
cmovl S0, P0
cmovl P0, P2
cmp P1, P3
cmovle S1, P1
cmovg S1, P3
mov P2, P0
cmovl P1, P3
cmp P0, P1
cmovl P2, P1
cmovle P1, P0
mov P2, S0
cmp S0, S1
