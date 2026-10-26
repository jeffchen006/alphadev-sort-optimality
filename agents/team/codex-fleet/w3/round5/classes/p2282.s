# n=5 model=out iset=I1 prefix14_class=2282
cmp P1, P2
mov S0, P3
cmovle S1, P1
cmovge S1, P2
cmovl P1, P2
mov S2, P1
cmp S0, P0
cmovl S0, P0
cmovg P3, P0
cmp P1, S0
cmovle P1, S0
mov P1, S1
cmovle S0, S2
cmp P3, S1
