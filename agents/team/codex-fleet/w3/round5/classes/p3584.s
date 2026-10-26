# n=5 model=out iset=I1 prefix14_class=3584
cmp P1, P2
cmovl S0, P1
cmovl P1, P2
mov S2, P3
cmovl P2, S0
cmp P0, S2
cmovge S2, P0
mov S1, P1
cmovl P3, P0
cmp P3, P2
cmovg S0, P2
cmovle S0, P3
cmovge P2, P3
mov S0, P2
