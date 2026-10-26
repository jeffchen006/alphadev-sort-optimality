# n=5 model=out iset=I1 prefix14_class=4679
cmp P3, P2
cmovge S1, P2
cmovg P2, P3
cmovg P3, S1
mov S1, P1
cmp P0, S1
cmovge P1, P0
cmovle S1, P0
cmovl P0, P1
cmp P0, P2
cmovle P1, P2
cmovg P0, P2
mov P1, S1
cmp S1, P3
