# n=5 model=out iset=I1 prefix14_class=2735
mov S1, P3
cmp S1, P0
cmovge S1, P0
cmovg P0, P3
mov S2, P2
cmp P1, S2
cmovle P2, P1
cmovl P1, S2
mov S0, P0
cmp P1, S0
cmovl S0, P1
cmovle P1, P0
cmp P2, S1
cmovle S2, S1
