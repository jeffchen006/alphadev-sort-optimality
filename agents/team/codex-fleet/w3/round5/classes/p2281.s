# n=5 model=out iset=I1 prefix14_class=2281
cmp P1, P2
mov S1, P1
cmovle P1, P2
cmovg S1, P2
cmovge P2, P1
mov S0, P3
cmp P3, P0
cmovl P3, P0
cmovge S0, P0
cmp P2, P3
cmovle P1, P3
cmovl P3, P2
mov P2, P3
cmp S1, S0
