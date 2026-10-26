# n=5 model=out iset=I1 prefix14_class=9110
cmp P1, P2
cmovge S1, P2
cmovl S1, P1
cmovle P1, P2
cmp P3, P0
cmovge S2, P3
cmovg P3, P0
cmovge P0, S2
cmp P3, S1
cmovge S0, P3
cmovl S0, S1
cmovl S1, P3
cmp P1, P0
cmovge P2, P1
