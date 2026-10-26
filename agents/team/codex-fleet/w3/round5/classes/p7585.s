# n=5 model=out iset=I1 prefix14_class=7585
cmp P2, P0
cmovge S0, P0
cmovg P0, P2
cmovl S0, P2
cmp P3, P1
cmovg S1, P1
cmovle S1, P3
cmovl P3, P1
cmp S0, S1
cmovl P2, S0
cmovle S0, S1
cmovl S1, P2
cmp P3, P0
mov S1, P0
