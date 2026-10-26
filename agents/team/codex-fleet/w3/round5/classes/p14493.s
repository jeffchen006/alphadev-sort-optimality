# n=5 model=out iset=I1 prefix14_class=14493
mov S0, P0
cmp S0, P1
cmovge S0, P1
cmovg P1, P0
cmp P2, P3
mov S1, S0
cmovle S2, P3
cmovl P3, P2
cmovl P2, S2
cmp S1, P3
cmovle S0, P3
cmovl P3, S1
cmp P2, P1
cmovle S1, P2
