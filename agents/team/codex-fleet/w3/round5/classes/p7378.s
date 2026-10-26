# n=5 model=out iset=I1 prefix14_class=7378
mov S2, P2
cmp P2, P1
mov S1, P0
cmovl P2, P1
cmovle P1, S2
cmp P3, P0
cmovle S1, P3
cmovg P0, P3
mov S2, P1
cmp S2, S1
cmovge P1, S1
cmovl S2, S1
cmp P2, P0
cmovle S1, P0
