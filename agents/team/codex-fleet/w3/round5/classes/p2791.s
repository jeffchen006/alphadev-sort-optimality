# n=5 model=out iset=I1 prefix14_class=2791
mov S0, P2
cmp P0, P2
cmovl P2, P0
cmovge S0, P0
mov S2, P3
cmp P3, P1
cmovle P3, P1
cmovge S2, P1
mov S1, S0
cmp P3, S1
cmovg S1, P3
cmovge P3, S0
cmp S2, P2
cmovle P0, S2
