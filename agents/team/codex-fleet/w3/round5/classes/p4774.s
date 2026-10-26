# n=5 model=out iset=I1 prefix14_class=4774
cmp P1, P2
cmovl S0, P1
cmovl P1, P2
cmovl P2, S0
mov S2, P0
cmp S2, P3
cmovle P0, P3
cmovge S2, P3
cmp S2, P2
cmovg S0, P2
cmovg P2, S2
cmovg S2, S0
cmp P1, P0
cmovle S1, P1
