# n=5 model=out iset=I1 prefix14_class=11630
cmp P0, P2
cmovl S1, P0
mov S2, P1
cmovl P0, P2
mov S0, P0
cmovge S1, P2
cmp P1, P3
cmovge S2, P3
cmovg P3, P1
cmp P0, P3
cmovl P0, P3
cmovg S0, P3
cmp S1, S2
cmovle P3, S1
