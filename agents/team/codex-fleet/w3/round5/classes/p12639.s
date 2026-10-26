# n=5 model=out iset=I1 prefix14_class=12639
mov S2, P2
cmp S2, P3
mov S1, P1
cmovl P2, P3
cmovge S2, P3
cmp P0, P1
cmovle S1, P0
cmovle P0, P1
cmp S1, S2
cmovle P1, S2
cmovle S2, S1
cmovl S1, P1
mov S0, S1
cmp P2, P0
