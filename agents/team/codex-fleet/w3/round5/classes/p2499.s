# n=5 model=out iset=I1 prefix14_class=2499
mov S1, P0
cmp P1, S1
cmovl P0, P1
mov S0, P2
cmovl P1, S1
cmp P3, P2
cmovge S0, P3
cmovg P3, P2
cmp S0, P1
cmovle S2, P1
cmovl P1, S0
cmovge S2, S0
cmp P0, P3
cmovge S0, P0
