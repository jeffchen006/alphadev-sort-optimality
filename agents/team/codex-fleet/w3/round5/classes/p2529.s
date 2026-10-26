# n=5 model=out iset=I1 prefix14_class=2529
cmp P2, P3
cmovge S0, P3
cmovle S0, P2
cmovl P2, P3
mov S1, P0
cmp S1, P1
cmovle S1, P1
mov S2, P2
cmovle P1, P0
cmp P2, S1
cmovl S2, S1
cmovg P2, S1
cmp P1, S0
cmovge S2, P1
