# n=5 model=out iset=I1 prefix14_class=13714
cmp P1, P0
cmovge S2, P1
cmovle S2, P0
cmovg P1, P0
mov S0, P3
cmp P2, P3
cmovle P3, P2
cmovge S0, P2
cmp P1, P3
cmovl P0, P1
cmovl P1, P3
cmovl P3, P0
cmp S0, S2
mov S1, S0
