# n=5 model=out iset=I1 prefix14_class=12948
cmp P1, P3
cmovl S2, P3
cmovge S2, P1
cmovg P1, P3
cmp P2, P0
mov S0, S2
mov S1, P2
cmovg S1, P0
cmovg P0, P2
cmp S1, P1
cmovle P2, S1
cmovl S1, P1
cmovl P1, P2
cmp P0, S0
