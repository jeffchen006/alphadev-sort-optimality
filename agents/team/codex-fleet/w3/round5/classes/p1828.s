# n=5 model=out iset=I1 prefix14_class=1828
cmp P2, P0
cmovg S2, P0
cmovg P0, P2
cmovg P2, S2
mov S0, P3
cmp P1, P3
cmovge P3, P1
cmovge P1, S0
cmp P3, P0
cmovge S2, P0
cmovl S2, P3
cmovle P3, P0
cmp P1, P2
cmovl P0, P2
