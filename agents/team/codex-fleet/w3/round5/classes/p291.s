# n=5 model=out iset=I1 prefix14_class=291
cmp P3, P1
mov S2, P0
cmovge S1, P3
cmovg P3, P1
cmovg P1, S1
cmp P2, P0
cmovl P0, P2
cmovge S2, P2
cmp P0, P3
mov S1, P3
cmovle P3, P0
cmovl P0, S1
cmp S2, P1
cmovle S0, P1
