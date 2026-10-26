# n=5 model=out iset=I1 prefix14_class=14419
mov S1, P0
cmp P1, S1
mov S0, P3
cmovl S1, P1
cmovle P1, P0
cmp P3, P2
cmovl P3, P2
cmovle P2, S0
cmp P2, S1
cmovg S0, P2
cmovg P2, S1
cmovg S1, S0
cmp P1, P3
cmovge S2, P1
