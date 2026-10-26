# n=5 model=out iset=I1 prefix14_class=13516
cmp P1, P0
mov S0, P0
cmovg P0, P1
cmovl S0, P1
cmp P2, P3
cmovle P1, P3
cmovl P3, P2
mov S1, S0
cmovl P2, P1
cmp S1, P3
cmovle S0, P3
mov S2, P2
cmovge S1, P3
cmp P2, P0
