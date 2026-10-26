# n=5 model=out iset=I1 prefix14_class=10040
cmp P2, P3
mov S1, P2
mov S0, P1
cmovl P2, P3
cmovge S1, P3
cmp P1, P0
cmovle P1, P0
cmovg S0, P0
mov S2, P2
cmp P1, S2
cmovge S2, P1
cmovle P2, P1
cmp S0, S1
cmovge P3, S0
