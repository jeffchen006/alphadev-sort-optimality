# n=5 model=out iset=I1 prefix14_class=1652
mov S1, P3
cmp P1, P3
cmovge S1, P1
cmovge P1, P3
mov S2, S1
mov S0, P0
cmp P2, S0
mov P3, P1
cmovg S0, P2
cmovle P0, P2
cmp P3, P0
cmovle P3, P0
cmovl P0, P1
cmp S1, S0
