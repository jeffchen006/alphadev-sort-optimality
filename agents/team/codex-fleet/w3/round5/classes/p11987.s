# n=5 model=out iset=I1 prefix14_class=11987
cmp P2, P0
mov S1, P2
mov S2, P3
cmovl P2, P0
cmovge S1, P0
cmp S2, P1
cmovle P3, P1
cmovle P1, S2
cmp P1, S1
cmovle P0, S1
cmovle S1, P1
cmovl P1, P0
cmp P3, P2
cmovle P0, P3
