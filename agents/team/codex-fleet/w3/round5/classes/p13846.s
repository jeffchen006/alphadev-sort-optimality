# n=5 model=out iset=I1 prefix14_class=13846
mov S1, P3
mov S2, P0
cmp S2, P2
cmovl P0, P2
cmovge S2, P2
cmp P1, P3
cmovg P3, P1
cmovle S1, P1
cmp P0, P3
cmovle P2, P3
cmovle P3, P0
cmovl P0, P2
cmp S1, S2
cmovge P1, S1
