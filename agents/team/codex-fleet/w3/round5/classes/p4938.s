# n=5 model=out iset=I1 prefix14_class=4938
mov S0, P1
cmp S0, P3
cmovg S0, P3
cmovl P1, P3
mov S1, P2
cmp P2, P0
cmovl P2, P0
cmovle P0, S1
mov S2, S0
cmp S0, P0
cmovg S2, P0
cmovg P0, S0
cmp P2, P1
cmovge S1, P2
