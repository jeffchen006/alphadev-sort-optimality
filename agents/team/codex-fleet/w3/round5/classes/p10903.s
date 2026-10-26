# n=5 model=out iset=I1 prefix14_class=10903
mov S2, P3
cmp P3, P0
cmovl P3, P0
cmovl P0, S2
cmp P2, P1
mov S1, P1
cmovle S1, P2
cmovge P1, P2
cmp P1, P3
cmovl S0, P1
cmovl P1, P3
cmovl P3, S0
cmp P0, S1
cmovle S0, S1
