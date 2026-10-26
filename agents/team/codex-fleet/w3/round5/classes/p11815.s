# n=5 model=out iset=I1 prefix14_class=11815
cmp P2, P3
cmovge S2, P3
cmovg P3, P2
cmovg P2, S2
mov S0, P1
cmp P1, P0
cmovle S0, P0
mov S1, S0
cmovl P0, P1
cmp P3, S0
cmovl S1, P3
cmovg S0, P3
cmp P0, P2
cmovl S2, P2
