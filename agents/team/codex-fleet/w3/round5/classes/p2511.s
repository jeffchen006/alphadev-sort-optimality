# n=5 model=out iset=I1 prefix14_class=2511
mov S1, P2
cmp P1, P0
mov S0, P0
cmovle S0, P1
cmovl P1, P0
cmp P3, S1
cmovl P2, P3
cmovge S1, P3
mov S2, P1
cmp S2, S1
cmovg P1, S1
cmovl S2, S1
cmp P2, S0
cmovge S1, P2
