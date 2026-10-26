# n=5 model=out iset=I1 prefix14_class=6429
cmp P3, P2
cmovge S0, P2
cmovl S0, P3
cmovg P2, P3
cmp P0, P1
cmovg P3, P1
cmovg P1, P0
cmovle P3, P0
cmp P1, P2
cmovle S1, P2
cmovle P2, P1
cmovge S1, P1
cmp P3, S0
cmovl S2, S0
