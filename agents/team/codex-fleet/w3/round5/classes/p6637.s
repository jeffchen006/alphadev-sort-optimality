# n=5 model=out iset=I1 prefix14_class=6637
cmp P0, P3
mov S0, P2
mov S1, P3
cmovg S1, P0
cmovl P3, P0
cmp P2, P1
cmovl P2, P1
cmovle P1, S0
cmp S1, P2
cmovge S2, S1
mov S0, P1
cmovg S1, P2
cmovge P2, S2
cmp P3, P1
