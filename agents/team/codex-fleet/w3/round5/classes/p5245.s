# n=5 model=out iset=I1 prefix14_class=5245
mov S0, P3
cmp P3, P2
cmovg P3, P2
cmovg P2, S0
cmp P1, P0
cmovl S1, P0
cmovl P0, P1
cmovl P1, S1
cmp P3, P0
cmovge S2, P0
cmovl S2, P3
cmovge P0, P3
cmp P1, P2
cmovle S0, P2
