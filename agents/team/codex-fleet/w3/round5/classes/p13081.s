# n=5 model=out iset=I1 prefix14_class=13081
mov S0, P0
cmp P2, P0
cmovg P0, P2
cmovl S0, P2
cmp P1, P3
mov P2, S0
cmovle S1, P1
cmovl P1, P3
cmovl P3, S1
cmp P3, S0
cmovge P2, P3
cmovle S0, P3
cmp P0, P1
mov S2, P2
