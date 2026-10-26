# n=5 model=out iset=I1 prefix14_class=11123
cmp P1, P3
mov S2, P3
cmovge S2, P1
cmovle P3, P1
mov S1, P0
cmovle P1, S2
cmp P2, S1
cmovl P0, P2
cmovl P2, S1
cmp S2, P2
cmovge S2, P2
cmovle P1, P2
cmp P0, P3
cmovg P2, P3
