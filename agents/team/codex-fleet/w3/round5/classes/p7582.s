# n=5 model=out iset=I1 prefix14_class=7582
cmp P2, P0
cmovge S0, P0
cmovg P0, P2
cmovl S0, P2
cmp P1, P3
cmovg P2, P3
cmovle P2, P1
cmovle P1, P3
cmp S0, P2
cmovl S1, S0
cmovle S0, P2
cmovl P2, S1
cmp P1, P0
cmovle P2, P0
