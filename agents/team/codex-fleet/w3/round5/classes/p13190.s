# n=5 model=out iset=I1 prefix14_class=13190
mov S2, P0
cmp P2, S2
cmovge S2, P2
cmovle P0, P2
cmp P1, P3
cmovle P2, P1
mov S1, P0
cmovle P1, P3
cmovle P3, P2
cmp P0, P3
cmovg P0, P3
cmovle S1, P3
cmp S2, P1
cmovl P0, P1
