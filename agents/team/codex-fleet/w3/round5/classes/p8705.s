# n=5 model=out iset=I1 prefix14_class=8705
cmp P2, P0
cmovle S2, P0
cmovge S2, P2
cmovle P0, P2
cmp P3, P1
cmovg P2, P3
cmovge P3, P1
cmovg P1, P2
cmp S2, P1
cmovle P2, P1
cmovl P1, S2
mov S1, P0
cmovle S2, P2
cmp P3, P0
