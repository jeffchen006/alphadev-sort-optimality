# n=5 model=out iset=I1 prefix14_class=6902
cmp P0, P1
mov S1, P1
cmovl S1, P0
cmovle P0, P1
mov P1, P2
cmp P1, P3
cmovge P1, P3
cmovl P2, P3
cmp P0, P2
mov S2, P2
cmovg P2, P0
cmovle S2, P0
cmp S1, P1
cmovge P0, P1
