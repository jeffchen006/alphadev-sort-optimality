# n=5 model=out iset=I1 prefix14_class=2120
cmp P3, P0
cmovg S2, P0
cmovle S2, P3
cmovge P0, P3
mov P3, P1
cmp P3, P2
cmovle P1, P2
cmovge P3, P2
mov P2, P1
cmp P1, P0
cmovge P1, P0
cmovl P2, P0
cmp S2, P3
cmovle P2, S2
