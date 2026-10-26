# n=5 model=out iset=I1 prefix14_class=10237
mov S0, P0
cmp P0, P2
cmovge S0, P2
cmovge P2, P0
cmp P1, P3
cmovge S1, P3
cmovg P3, P1
cmovg P1, S1
cmp P3, P2
cmovl P0, P3
cmovle P3, P2
cmovge P0, P2
cmp S0, P1
cmovge S1, P1
