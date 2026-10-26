# n=5 model=out iset=I1 prefix14_class=14127
mov S1, P0
cmp S1, P1
mov S2, P2
cmovl S1, P1
cmovge P0, P1
cmp P3, S2
cmovg P2, P3
cmovle S2, P3
cmp S1, P2
cmovle P1, S1
cmovl S1, P2
cmovle P2, P1
cmp P0, S2
cmovle P3, P0
