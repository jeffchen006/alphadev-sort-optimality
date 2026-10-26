# n=5 model=out iset=I1 prefix14_class=4488
cmp P1, P2
cmovge S2, P1
cmovl S2, P2
mov S0, P0
cmovg P1, P2
cmp P0, P3
cmovg S0, P3
cmovle P0, P3
cmp P0, S2
cmovg P3, P0
cmovge P0, S2
cmovg S2, P3
cmp P1, S0
cmovge S2, P1
