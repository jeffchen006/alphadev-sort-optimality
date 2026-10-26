# n=5 model=out iset=I1 prefix14_class=14367
cmp P0, P2
cmovle S0, P0
cmovl P0, P2
cmovg S0, P2
mov S2, P0
cmp P3, P1
cmovl S1, P3
cmovge S1, P1
cmovge P1, P3
cmp S0, S1
cmovle P3, S0
cmovl S0, S1
cmovl S1, P3
cmp P1, P0
