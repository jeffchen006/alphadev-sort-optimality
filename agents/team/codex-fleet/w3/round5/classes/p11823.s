# n=5 model=out iset=I1 prefix14_class=11823
mov S2, P2
cmp P3, P0
cmovl S1, P3
cmovle P3, P0
cmovl P0, S1
cmp S2, P1
cmovle S2, P1
cmovl P1, P2
cmp P3, S2
cmovge P2, P3
cmovg P3, S2
cmovle P2, S2
cmp P0, P1
cmovge S2, P0
