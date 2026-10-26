# n=5 model=out iset=I1 prefix14_class=7847
mov S2, P0
cmp P0, P2
cmovge S2, P2
cmovl P0, P2
cmovl P2, S2
cmp P3, P1
cmovle S0, P1
cmovl P1, P3
cmovl P3, S0
cmp P1, S2
cmovl S2, P1
cmovge P2, P1
cmp P3, P0
mov S2, P0
