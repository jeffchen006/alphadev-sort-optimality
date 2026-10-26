# n=5 model=out iset=I1 prefix14_class=10562
cmp P1, P2
cmovge S0, P1
cmovl S0, P2
cmovl P2, P1
cmovl P1, S0
mov S2, P0
cmp P0, P3
cmovge S2, P3
cmovg P3, P0
cmp S0, P3
cmovg S0, P3
cmovle P1, P3
cmp S2, P2
cmovle S1, P2
