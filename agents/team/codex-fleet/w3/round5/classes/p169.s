# n=5 model=out iset=I1 prefix14_class=169
mov S1, P2
cmp P2, P3
cmovge S1, P3
mov S0, P0
cmovl P2, P3
cmp P1, P0
cmovle P0, P1
cmovle P1, S0
cmp S1, P0
mov S2, P0
cmovg S2, S1
cmovge S1, P0
mov S0, S2
cmp P2, P1
