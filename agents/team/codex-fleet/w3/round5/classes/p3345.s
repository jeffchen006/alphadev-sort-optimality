# n=5 model=out iset=I1 prefix14_class=3345
mov S0, P2
cmp P0, P1
mov S1, P1
cmovg P1, P0
cmovl S1, P0
cmp P3, P2
cmovge S0, P3
cmovl P2, P3
cmp P2, S1
cmovge S2, S1
cmovg S1, P2
cmovl S2, P2
cmp P1, S0
cmovle P0, P1
