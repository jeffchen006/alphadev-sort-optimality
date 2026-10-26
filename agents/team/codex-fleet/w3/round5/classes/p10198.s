# n=5 model=out iset=I1 prefix14_class=10198
cmp P2, P0
cmovg S1, P2
cmovg P2, P0
mov S0, P1
cmovg P0, S1
cmp P3, S0
cmovl P1, P3
cmovge S0, P3
cmp P0, S0
cmovl S2, P0
cmovle P0, S0
cmovl S0, S2
mov P0, P1
cmp P2, P1
