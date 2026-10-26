# n=5 model=out iset=I1 prefix14_class=11589
mov S1, P0
cmp S1, P1
cmovl P0, P1
cmovge S1, P1
mov S0, P0
cmp P2, P3
cmovle S2, P2
cmovle P2, P3
cmovg S2, P3
cmp S2, S1
cmovl P3, S1
cmovl S1, S2
cmovl S2, P3
cmp P0, P2
