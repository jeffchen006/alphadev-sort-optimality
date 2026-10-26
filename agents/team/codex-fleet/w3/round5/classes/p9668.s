# n=5 model=out iset=I1 prefix14_class=9668
mov S2, P2
mov S1, P1
cmp P2, P0
cmovg S2, P0
cmovle P2, P0
cmp P1, P3
cmovl P1, P3
cmovle P3, S1
cmp P1, P2
cmovge S0, P2
cmovg P2, P1
cmovg P1, S0
cmp S2, P3
cmovl S0, P3
