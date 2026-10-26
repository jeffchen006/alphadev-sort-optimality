# n=5 model=out iset=I1 prefix14_class=7544
cmp P0, P2
cmovle S1, P0
cmovge S1, P2
cmovg P2, P0
cmp P1, P3
cmovge S0, P3
cmovge P3, P1
cmovg P1, S0
cmp S1, P1
cmovge P0, S1
cmovle P0, P1
cmovl P1, S1
cmp P2, P3
cmovle P1, P2
