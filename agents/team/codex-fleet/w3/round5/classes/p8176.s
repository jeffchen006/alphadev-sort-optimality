# n=5 model=out iset=I1 prefix14_class=8176
mov S0, P3
cmp S0, P2
cmovle P3, P2
mov S1, P0
cmovl P2, S0
cmp P1, S1
cmovle P0, P1
cmovle P1, S1
cmp P0, P2
cmovge S2, P0
cmovg P0, P2
cmovg P2, S2
cmp P1, P3
cmovge S1, P1
