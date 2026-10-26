# n=5 model=out iset=I1 prefix14_class=13598
cmp P2, P0
cmovg S1, P2
cmovle S1, P0
cmovl P0, P2
cmp P3, P1
cmovl S0, P1
cmovle P1, P3
cmovl P3, S0
cmp P1, P0
cmovle S0, P0
cmovl P0, P1
cmovle P1, S0
cmp S1, P3
cmovge S0, P3
