# n=5 model=out iset=I1 prefix14_class=8640
mov S2, P3
cmp P0, S2
mov S0, P1
cmovle P3, P0
cmovg S2, P0
mov S1, S2
cmp P1, P2
cmovle P1, P2
cmovg S0, P2
cmp P1, S2
cmovl S2, P1
cmovge S1, P1
cmp P3, S0
cmovl P1, P3
