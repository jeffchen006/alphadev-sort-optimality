# n=5 model=out iset=I1 prefix14_class=6514
cmp P3, P2
cmovle S1, P3
cmovge S1, P2
cmovge P2, P3
cmp P1, P0
cmovg P3, P0
cmovle P3, P1
cmovle P1, P0
cmovge P0, P1
cmp P2, P1
cmovle P1, P2
cmovl P2, P0
cmp S1, P3
cmovl S0, P3
