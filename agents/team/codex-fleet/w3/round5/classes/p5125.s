# n=5 model=out iset=I1 prefix14_class=5125
mov S1, P0
cmp P0, P1
cmovle S1, P1
cmovg P0, P1
cmovle P1, P0
mov S2, P2
cmp P2, P3
cmovl S2, P3
cmovge P2, P3
cmp P2, P0
cmovle P1, P2
cmovg P0, P2
cmp S1, S2
cmovl P1, S2
