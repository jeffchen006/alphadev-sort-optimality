# n=5 model=out iset=I1 prefix14_class=13603
cmp P1, P0
cmovl S2, P0
cmovl P0, P1
cmovge S2, P1
cmp P3, P2
cmovle S0, P2
cmovl P2, P3
cmovl P3, S0
cmp P2, P0
cmovl S0, P0
cmovl P0, P2
cmovl P2, S0
cmp P3, S2
cmovge S0, S2
