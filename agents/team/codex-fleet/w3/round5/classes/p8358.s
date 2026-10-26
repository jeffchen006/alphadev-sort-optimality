# n=5 model=out iset=I1 prefix14_class=8358
mov S0, P1
cmp P1, P2
cmovl P1, P2
cmovle P2, S0
mov S1, P3
cmp P0, P3
cmovl P3, P0
cmovg S1, P0
cmp P3, P2
cmovge S2, P2
cmovg P2, P3
mov S0, P1
cmovge P3, S2
cmp S0, S1
