# n=5 model=out iset=I1 prefix14_class=7547
cmp P0, P1
cmovge S0, P1
cmovle S0, P0
cmovg P1, P0
mov S2, P2
cmovg P0, S0
cmp P3, S2
cmovge S2, P3
cmovg P3, P2
cmp P0, P3
cmovl P0, P3
cmovl P3, S0
cmp P1, S2
cmovle S0, P1
