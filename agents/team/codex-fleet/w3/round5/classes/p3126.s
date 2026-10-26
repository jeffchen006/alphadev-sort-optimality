# n=5 model=out iset=I1 prefix14_class=3126
cmp P0, P3
cmovge S2, P3
cmovle S2, P0
cmovge P3, P0
mov S1, P2
cmp P1, P2
cmovg S1, P1
cmovle P2, P1
mov P0, P2
cmp P2, S2
cmovge P0, S2
mov P0, P3
cmovl P2, S2
cmp S1, P3
