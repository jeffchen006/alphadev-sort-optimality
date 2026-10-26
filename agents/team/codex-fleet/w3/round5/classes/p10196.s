# n=5 model=out iset=I1 prefix14_class=10196
cmp P1, P0
cmovg S1, P1
cmovg P1, P0
mov S0, P2
cmovg P0, S1
cmp P3, S0
cmovl P2, P3
cmovge S0, P3
cmp P0, S0
mov S2, P0
cmovle P0, S0
cmovl S0, S2
cmp P1, P2
mov P0, P2
