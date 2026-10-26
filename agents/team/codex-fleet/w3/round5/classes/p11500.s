# n=5 model=out iset=I1 prefix14_class=11500
mov S2, P3
mov S1, P2
cmp P3, P0
cmovl P3, P0
cmovle P0, S2
cmp S1, P1
cmovg P2, P1
cmovle S1, P1
cmp P0, P2
cmovle P1, P0
cmovl P0, P2
cmovle P2, P1
cmp S1, P3
cmovge S0, S1
