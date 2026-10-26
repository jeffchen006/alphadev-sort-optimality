# n=5 model=out iset=I1 prefix14_class=9932
mov S0, P0
cmp S0, P2
cmovl P0, P2
cmovle P2, S0
cmp P1, P3
cmovge S2, P1
cmovle S2, P3
cmovle P3, P1
cmp S2, P0
cmovl S1, S2
cmovge S1, P0
cmovl S2, P0
cmp P3, P2
cmovl S2, P2
