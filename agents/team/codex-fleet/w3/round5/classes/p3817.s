# n=5 model=out iset=I1 prefix14_class=3817
cmp P2, P3
mov S1, P2
cmovg S1, P3
mov S0, P1
cmovge P3, P2
cmp P0, S0
cmovl P1, P0
cmovge S0, P0
mov S2, P1
cmp S2, S1
cmovle S2, S1
cmovl S1, P1
mov P1, S2
cmp P3, S0
