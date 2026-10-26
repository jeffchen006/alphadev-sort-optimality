# n=5 model=out iset=I1 prefix14_class=5512
mov S1, P2
cmp P2, P1
cmovle S1, P1
cmovge P2, P1
mov S2, P3
cmp P3, P0
cmovle P3, P0
cmovle P0, S2
mov P1, P2
cmp P2, P0
cmovge P2, P0
cmovl P1, P0
cmp S1, P3
mov P2, P1
