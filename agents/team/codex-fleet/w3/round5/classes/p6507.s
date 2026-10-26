# n=5 model=out iset=I1 prefix14_class=6507
mov S2, P3
mov S1, P0
cmp P1, P3
cmovle P3, P1
cmovge S2, P1
cmp P2, S1
cmovle S1, P2
cmovl P2, P0
mov P1, P2
cmp S2, P1
cmovle P1, S2
cmovle S2, P2
cmp S1, P3
cmovl P0, P3
