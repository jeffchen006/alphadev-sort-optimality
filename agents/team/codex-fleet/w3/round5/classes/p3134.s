# n=5 model=out iset=I1 prefix14_class=3134
cmp P0, P3
mov S0, P2
mov S1, P0
cmovge S1, P3
cmovge P3, P0
cmp P1, S0
cmovg S0, P1
cmovle P2, P1
cmp S1, P2
cmovge P1, S1
cmovge S1, P2
cmovl P1, P2
cmp S0, P3
cmovg S2, P3
