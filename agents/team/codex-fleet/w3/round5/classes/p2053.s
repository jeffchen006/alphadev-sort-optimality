# n=5 model=out iset=I1 prefix14_class=2053
mov S2, P1
cmp P0, P3
mov S1, P0
cmovle S1, P3
cmovl P3, P0
cmp S2, P2
cmovge P1, P2
cmovge P2, S2
mov P0, P2
cmp P0, S1
cmovle P2, S1
cmovge P0, S1
mov S1, P1
cmp S1, P3
