# n=5 model=out iset=I1 prefix14_class=4865
mov S1, P0
cmp S1, P1
cmovg S1, P1
cmovg P1, P0
cmp P2, P3
cmovge S2, P2
cmovle S2, P3
cmovge P2, P3
cmp P2, S1
cmovle P3, P2
mov P0, S2
cmovl P2, S1
cmovle S1, P3
cmp P1, S2
