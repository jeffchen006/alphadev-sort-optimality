# n=5 model=out iset=I1 prefix14_class=8582
mov S2, P1
mov S1, P2
cmp P1, P0
cmovle P1, P0
cmovl P0, S2
cmp S1, P3
cmovge S1, P3
mov S0, P1
cmovl P2, P3
cmp P1, P2
cmovl P1, P2
cmovg S0, P2
cmp P0, S1
cmovge P1, S1
