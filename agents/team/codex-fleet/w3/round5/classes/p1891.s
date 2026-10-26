# n=5 model=out iset=I1 prefix14_class=1891
mov S1, P2
cmp P1, P0
mov S2, P0
cmovl P0, P1
cmovl P1, S2
cmp P3, P2
cmovle P2, P3
cmovge S1, P3
mov S0, P1
cmp S1, S0
cmovl S0, S1
cmovle S1, P1
mov S1, S0
mov S2, P0
