# n=5 model=out iset=I1 prefix14_class=90
mov S2, P1
mov S1, P3
cmp P0, S2
cmovg S2, P0
cmovge P0, P1
cmp P2, P3
cmovle P3, P2
cmovg S1, P2
cmovl P2, S1
cmp P3, P0
cmovge S0, P0
cmovl S0, P3
cmovge P0, P3
cmp P2, S2
