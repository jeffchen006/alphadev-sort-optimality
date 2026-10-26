# n=5 model=out iset=I1 prefix14_class=10329
mov S1, P0
cmp P3, P0
cmovg P0, P3
mov S2, P2
cmovle S1, P3
cmp P2, P1
cmovl P2, P1
cmovle P1, S2
cmp P2, P0
cmovg P3, P2
cmovge P2, P0
cmovg P0, P3
cmp S1, P1
cmovge P3, S1
