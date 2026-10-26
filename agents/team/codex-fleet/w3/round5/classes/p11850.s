# n=5 model=out iset=I1 prefix14_class=11850
cmp P3, P1
mov S0, P3
cmovl P3, P1
cmovge S0, P1
cmp P2, P0
cmovle P1, P2
cmovle P2, P0
cmovle P0, P1
cmp P3, P2
mov S2, P2
cmovl P2, P3
cmovle P3, S2
mov S1, P0
cmp S0, S1
