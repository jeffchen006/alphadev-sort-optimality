# n=5 model=out iset=I1 prefix14_class=5112
cmp P1, P3
mov S0, P2
cmovle S1, P1
cmovle P1, P3
cmovg S1, P3
cmp P2, P0
cmovge S0, P0
cmovl P2, P0
mov P3, S0
cmp S1, P3
cmovge P3, S1
cmovl S0, S1
mov S0, P3
mov S2, P2
