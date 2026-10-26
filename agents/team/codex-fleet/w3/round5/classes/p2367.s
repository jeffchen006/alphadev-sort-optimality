# n=5 model=out iset=I1 prefix14_class=2367
cmp P2, P0
cmovge S1, P2
cmovge P2, P0
cmovle S1, P0
cmp P3, P1
cmovle S0, P1
cmovl P1, P3
cmovl P3, S0
cmp S1, P3
mov S0, P3
cmovg P3, S1
cmovl S0, S1
cmp P2, P1
cmovge S1, P2
