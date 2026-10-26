# n=5 model=out iset=I1 prefix14_class=414
mov S1, P0
cmp P3, P0
mov S0, P1
cmovle P0, P3
cmovg S1, P3
cmp P1, P2
cmovg S0, P2
cmovg P2, P1
cmp P0, S0
cmovle P3, P0
cmovg P3, S0
cmovl P0, S0
cmp S1, P2
cmovge S2, P2
