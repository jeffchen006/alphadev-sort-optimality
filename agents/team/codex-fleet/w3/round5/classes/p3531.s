# n=5 model=out iset=I1 prefix14_class=3531
cmp P2, P3
mov S0, P1
cmovg S2, P3
cmovg P3, P2
cmovg P2, S2
cmp P1, P0
cmovle P1, P0
cmovl P0, S0
cmp P0, P2
cmovl S1, P0
mov S0, P1
cmovge S1, P2
cmovg P2, P0
cmp P3, P1
