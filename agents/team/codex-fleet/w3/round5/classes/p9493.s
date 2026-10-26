# n=5 model=out iset=I1 prefix14_class=9493
cmp P1, P0
mov S1, P0
cmovl P0, P1
cmovge S1, P1
cmp P3, P2
cmovge S2, P3
cmovge P3, P2
cmovg P2, S2
cmp P0, P3
cmovge P1, P3
cmovle P1, P0
cmovle P0, P3
cmp S1, P2
cmovl P3, S1
