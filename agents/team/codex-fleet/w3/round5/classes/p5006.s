# n=5 model=out iset=I1 prefix14_class=5006
mov S0, P0
cmp P0, P3
cmovl P0, P3
cmovl P3, S0
mov S2, P1
cmp P2, S2
cmovge S2, P2
mov S0, P3
cmovle P1, P2
cmp P1, P3
cmovle P3, P1
cmovl P1, S0
mov P3, P0
cmp P3, S2
