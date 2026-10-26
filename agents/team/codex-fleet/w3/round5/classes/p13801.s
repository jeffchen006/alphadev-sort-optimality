# n=5 model=out iset=I1 prefix14_class=13801
mov S2, P3
cmp P3, P0
cmovge S2, P0
mov S1, P2
cmovle P3, P0
cmp S1, P1
cmovle P2, P1
cmovge S1, P1
cmp P3, P2
cmovle P0, P2
cmovl P2, P3
cmovle P3, P0
cmp S2, S1
cmovg P0, S2
