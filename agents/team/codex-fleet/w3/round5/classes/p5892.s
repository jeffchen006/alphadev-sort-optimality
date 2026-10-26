# n=5 model=out iset=I1 prefix14_class=5892
cmp P3, P0
cmovge S1, P0
mov S2, P1
cmovge P0, P3
cmovg P3, S1
cmp P2, S2
cmovle P1, P2
cmovl P2, S2
mov S0, P0
cmp P2, P0
cmovge P0, P2
cmovl S0, P2
cmp P3, P1
cmovle P0, P3
