# n=5 model=out iset=I1 prefix14_class=9843
mov S1, P0
cmp P2, P0
cmovle P0, P2
cmovg S1, P2
mov S2, P1
cmp P1, P3
cmovg P1, P3
cmovl S2, P3
cmp S1, S2
cmovge S0, S1
cmovg S1, S2
cmovl S0, S2
cmp P1, P0
cmovl P2, P0
