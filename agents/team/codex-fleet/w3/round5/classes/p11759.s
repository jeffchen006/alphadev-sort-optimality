# n=5 model=out iset=I1 prefix14_class=11759
mov S0, P2
cmp P2, P0
cmovge S0, P0
cmovg P0, P2
cmp P3, P1
cmovl S2, P3
mov S1, P0
cmovle P3, P1
cmovl P1, S2
cmp P3, P0
cmovg P0, P3
cmovg P3, S1
cmp S0, P1
mov P0, S0
