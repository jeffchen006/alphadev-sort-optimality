# n=5 model=out iset=I1 prefix14_class=1431
mov S1, P3
cmp P1, P0
cmovge S0, P1
cmovge P1, P0
cmovg P0, S0
cmp P2, S1
mov S2, P1
cmovge S1, P2
cmovge P2, P3
mov P3, S1
cmp S1, P0
cmovl P3, P0
cmovge S1, P0
cmovle P0, S1
