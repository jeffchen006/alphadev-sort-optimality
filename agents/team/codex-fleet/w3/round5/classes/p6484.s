# n=5 model=out iset=I1 prefix14_class=6484
mov S1, P0
cmp S1, P1
cmovle S1, P1
cmovle P1, P0
cmp P2, P3
mov P0, P3
cmovl P3, P2
cmovg P0, P2
mov P2, S1
cmp S1, P0
cmovge P2, P0
cmovl S1, P0
cmp P3, P1
mov S1, P3
