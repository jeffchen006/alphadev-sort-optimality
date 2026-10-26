# n=5 model=out iset=I1 prefix14_class=8636
mov S1, P1
cmp P3, P1
mov S0, P2
cmovl P1, P3
cmovg S1, P3
cmp P0, S0
cmovl P2, P0
cmovge S0, P0
mov S2, S1
cmp S0, S1
cmovl S1, S0
cmovge S2, S0
cmp P1, P2
cmovle S2, P1
