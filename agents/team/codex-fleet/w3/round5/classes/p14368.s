# n=5 model=out iset=I1 prefix14_class=14368
mov S1, P0
cmp P2, S1
cmovge S1, P2
cmovg P2, P0
cmovl P0, P2
cmp P1, P3
cmovg S0, P1
cmovge P1, P3
cmovg P3, S0
cmp P0, P1
cmovg P2, P1
cmovle P0, P1
cmp S1, P3
cmovge P2, S1
