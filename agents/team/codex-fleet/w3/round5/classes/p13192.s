# n=5 model=out iset=I1 prefix14_class=13192
mov S2, P0
cmp P2, P0
cmovle S2, P2
cmovge P0, P2
mov S1, S2
cmp P1, P3
cmovl P2, P1
cmovle P1, P3
cmovl P3, P2
cmp S2, P3
cmovge S2, P3
cmovle S1, P3
cmp P1, P0
cmovle P2, P0
