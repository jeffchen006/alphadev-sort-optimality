# n=5 model=out iset=I1 prefix14_class=586
cmp P2, P3
mov S0, P0
cmovl S1, P2
cmovge S1, P3
cmovle P2, P3
cmovge P3, P2
cmp P0, P1
cmovg S0, P1
cmovge P1, P0
cmp P1, P2
mov S2, S0
cmovge P3, P1
cmovl P2, P1
cmp S1, S0
