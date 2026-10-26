# n=5 model=out iset=I1 prefix14_class=10038
mov S1, P3
cmp S1, P2
cmovge S1, P2
cmovl P3, P2
cmp P1, P0
cmovle S0, P1
cmovge S0, P0
cmovle P1, P0
mov S2, P3
cmp P1, S2
cmovge S2, P1
cmovl P3, P1
cmp S0, S1
cmovg P2, S0
