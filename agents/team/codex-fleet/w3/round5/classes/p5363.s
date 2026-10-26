# n=5 model=out iset=I1 prefix14_class=5363
mov S0, P1
cmp P2, P3
cmovg S2, P2
cmovge P2, P3
cmovle S2, P3
cmp P0, P1
cmovl S0, P0
cmovg P1, P0
cmovge P0, S0
cmp P2, S0
cmovge S0, P2
cmovl P0, P2
cmp P1, S2
cmovge P0, P1
