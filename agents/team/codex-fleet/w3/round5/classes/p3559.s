# n=5 model=out iset=I1 prefix14_class=3559
cmp P2, P0
cmovle S0, P2
cmovl P2, P0
cmovl P0, S0
cmp P3, P1
mov S1, P1
mov S0, P0
cmovl P1, P3
cmovg S1, P3
cmp P1, P0
cmovle S0, P1
cmovge P0, P1
cmp S1, P2
cmovl S2, P2
