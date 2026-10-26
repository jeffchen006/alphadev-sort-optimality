# n=5 model=out iset=I1 prefix14_class=12407
mov S1, P3
cmp P1, S1
mov S2, P0
cmovl S1, P1
cmovge P3, P1
cmp P2, S2
cmovg S2, P2
cmovle P0, P2
cmp S1, P0
cmovle P2, P0
cmovl P0, S1
cmovle S1, P2
mov P1, S2
cmp S2, P3
