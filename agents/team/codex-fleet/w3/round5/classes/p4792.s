# n=5 model=out iset=I1 prefix14_class=4792
mov S2, P0
cmp P1, P3
cmovle S0, P3
cmovg S0, P1
cmovl P3, P1
cmp S2, P2
cmovge S2, P2
cmovle P0, P2
cmp P3, S2
cmovg P2, P0
cmovg P1, P3
cmovle P1, S2
cmovl S2, P3
cmp S0, P0
