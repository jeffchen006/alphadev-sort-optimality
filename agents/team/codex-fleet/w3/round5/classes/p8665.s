# n=5 model=out iset=I1 prefix14_class=8665
mov S2, P2
cmp P0, S2
cmovg P2, P0
cmovge P0, S2
cmp P3, P1
cmovl S1, P1
cmovle P1, P3
cmovl P3, S1
cmp P2, P3
mov S0, P3
cmovge S0, P2
cmovge P2, P3
cmp P1, P0
cmovg S2, P0
