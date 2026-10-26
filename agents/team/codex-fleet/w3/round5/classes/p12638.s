# n=5 model=out iset=I1 prefix14_class=12638
mov S2, P2
cmp S2, P3
mov S1, P0
cmovl P2, P3
cmovge S2, P3
cmp P1, P0
cmovle S1, P1
cmovle P1, P0
cmp S1, S2
cmovl P0, S2
cmovle S2, S1
cmovl S1, P0
mov S0, S1
cmp P2, P1
