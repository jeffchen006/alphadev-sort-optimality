# n=5 model=out iset=I1 prefix14_class=313
cmp P1, P3
cmovge S1, P1
mov S2, P0
cmovge P1, P3
cmovg P3, S1
cmp P2, P0
cmovge P0, P2
cmovl S2, P2
cmp P1, S2
cmovle P2, P1
cmovge P2, S2
cmovl P1, S2
cmp P0, P3
cmovge S0, P3
