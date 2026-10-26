# n=5 model=out iset=I1 prefix14_class=6138
mov S1, P3
cmp S1, P1
cmovle P3, P1
cmovl P1, S1
cmp P2, P0
cmovge S1, P0
mov S2, P1
cmovge P0, P2
mov S0, P0
cmovge P2, S1
cmp P0, P3
cmovg S0, P3
cmovl P0, P3
cmp P2, P1
