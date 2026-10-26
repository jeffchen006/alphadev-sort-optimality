# n=5 model=out iset=I1 prefix14_class=194
mov S0, P2
cmp P1, S0
cmovge S0, P1
cmovg P1, P2
cmovle P2, P1
mov S2, P3
cmp P0, S2
cmovl P3, P0
cmovl P0, S2
cmp P3, P2
cmovg P1, P3
mov S1, P0
cmovle P2, P3
cmp S1, S0
