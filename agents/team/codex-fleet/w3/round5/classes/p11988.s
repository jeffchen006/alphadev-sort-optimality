# n=5 model=out iset=I1 prefix14_class=11988
cmp P0, P2
mov S1, P0
mov S2, P3
cmovl P0, P2
cmovge S1, P2
cmp S2, P1
cmovle P3, P1
cmovle P1, S2
cmp P1, S1
cmovle P2, S1
cmovle S1, P1
cmovl P1, P2
cmp P3, P0
cmovle P2, P3
