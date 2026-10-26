# n=5 model=out iset=I1 prefix14_class=9979
cmp P1, P3
cmovge S1, P3
cmovl S1, P1
mov S0, P0
cmovg P3, P1
cmp P2, S0
cmovge S0, P2
cmovle P0, P2
cmp S0, P3
cmovle S2, S0
cmovg S2, P3
cmovl S0, P3
cmp P0, S1
cmovl P2, P0
