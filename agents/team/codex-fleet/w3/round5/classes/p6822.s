# n=5 model=out iset=I1 prefix14_class=6822
mov S0, P2
cmp P1, P3
cmovge S2, P3
cmovl S2, P1
cmovle P1, P3
cmp P0, P2
cmovl P2, P0
cmovg S0, P0
mov P3, P2
cmp S0, P1
cmovge S1, P1
cmovge P1, S0
cmovg S0, S1
cmp S2, P3
