# n=5 model=out iset=I1 prefix14_class=9564
cmp P3, P2
mov S0, P3
cmovle P3, P2
mov S2, P1
cmovl P2, S0
cmp P1, P0
cmovg S2, P0
cmovle P1, P0
cmp P1, P3
cmovl S1, P3
cmovge S1, P1
cmovle P3, P1
cmp S2, P2
cmovle P1, S2
