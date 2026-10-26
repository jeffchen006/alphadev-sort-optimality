# n=5 model=out iset=I1 prefix14_class=4124
mov S1, P0
mov S0, P3
cmp P2, S1
cmovl P0, P2
cmovg S1, P2
cmp P1, P3
cmovle P3, P1
cmovg S0, P1
cmp P3, P0
cmovge S2, P0
cmovge P0, P3
cmovge P3, S2
cmp S0, S1
cmovge P2, S1
