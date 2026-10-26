# n=5 model=out iset=I1 prefix14_class=4056
mov S2, P0
mov S1, P1
cmp P1, P3
cmovg P1, P3
cmovg P3, S1
cmp P2, P0
cmovl S2, P2
cmovg P0, P2
cmp P1, S2
cmovge P2, P1
cmovle P2, S2
cmovle S2, P1
cmp P3, P0
cmovle S2, P3
