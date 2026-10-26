# n=5 model=out iset=I1 prefix14_class=6891
mov S2, P3
mov S0, P2
cmp P1, S0
cmovle P2, P1
cmovl P1, S0
cmp P3, P0
cmovl P3, P0
mov S1, P1
cmovg S2, P0
cmp P3, P1
cmovl P1, P3
cmovg S1, P3
cmp P2, S2
cmovge S0, S2
