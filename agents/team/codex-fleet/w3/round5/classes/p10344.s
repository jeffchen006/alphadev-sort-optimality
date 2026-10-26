# n=5 model=out iset=I1 prefix14_class=10344
mov S2, P1
cmp S2, P0
cmovle P1, P0
cmovl P0, S2
cmovge S2, P0
mov S1, P2
cmp S1, P3
cmovl S1, P3
cmovle P3, P2
cmp P1, S1
cmovge S0, S1
cmovge S1, P1
cmovg P1, S0
mov P2, P1
