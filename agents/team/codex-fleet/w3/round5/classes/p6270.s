# n=5 model=out iset=I1 prefix14_class=6270
mov S1, P3
mov S2, P0
cmp P1, S1
cmovle S1, P1
cmovl P1, P3
cmp P2, P0
mov P3, P1
cmovge P0, P2
cmovl S2, P2
cmp P0, P3
cmovle P3, P0
cmovl P0, P1
cmp S1, S2
mov P0, P3
