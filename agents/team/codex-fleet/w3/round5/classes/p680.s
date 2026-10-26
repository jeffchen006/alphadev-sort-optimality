# n=5 model=out iset=I1 prefix14_class=680
cmp P3, P1
mov S0, P1
cmovl P1, P3
cmovle P3, S0
cmovg S0, P3
mov S2, P0
cmp P0, P2
cmovl P0, P2
cmovg S2, P2
cmp P3, P0
cmovl P3, P0
cmovle P0, S0
cmp S2, P1
cmovge S0, S2
