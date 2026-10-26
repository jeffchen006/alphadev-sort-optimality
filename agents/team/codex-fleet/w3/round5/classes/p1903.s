# n=5 model=out iset=I1 prefix14_class=1903
cmp P2, P0
mov S0, P1
cmovl S1, P0
cmovl P0, P2
cmovl P2, S1
cmp P3, S0
cmovl S0, P3
cmovg P1, P3
cmp P2, P1
cmovle S2, P2
cmovge S2, P1
cmovl P2, P1
mov S1, S2
mov P3, S0
