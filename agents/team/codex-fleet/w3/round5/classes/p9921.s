# n=5 model=out iset=I1 prefix14_class=9921
cmp P3, P0
mov S1, P3
cmovg S1, P0
cmovl P3, P0
cmp P1, P2
mov S2, P3
mov S0, P2
cmovle P2, P1
cmovge S0, P1
cmp S2, S0
cmovge S2, S0
cmovl P3, S0
cmp S1, P2
cmovl S0, P2
