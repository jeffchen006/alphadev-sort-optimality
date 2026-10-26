# n=5 model=out iset=I1 prefix14_class=11831
mov S0, P2
cmp P1, P0
cmovle S1, P1
cmovl P1, P0
cmovl P0, S1
cmp P2, P3
cmovl S0, P3
cmovle P3, P2
cmp S0, P1
cmovge S2, P1
cmovle S2, S0
cmovge P1, S0
cmovg S0, S2
cmp P0, P3
