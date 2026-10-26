# n=5 model=out iset=I1 prefix14_class=10816
mov S1, P3
cmp P2, S1
cmovl S1, P2
cmovge P3, P2
cmp P0, P1
cmovg S0, P0
cmovle S0, P1
cmovl P1, P0
cmp S0, P3
cmovl S2, S0
cmovl S0, P3
cmovl P3, S2
cmp P1, S1
cmovge S0, S1
