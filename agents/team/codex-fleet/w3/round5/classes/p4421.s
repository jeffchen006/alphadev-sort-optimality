# n=5 model=out iset=I1 prefix14_class=4421
cmp P2, P0
mov S2, P1
cmovle S1, P2
cmovle P2, P0
cmovge S1, P0
cmp S2, P3
cmovg S2, P3
cmovge P3, P1
cmp P3, P2
mov P1, S2
cmovle P0, P3
cmovl P3, P2
cmovle P2, P0
mov P3, P2
