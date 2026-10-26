# n=5 model=out iset=I1 prefix14_class=14451
cmp P1, P0
cmovg S2, P0
cmovle S2, P1
cmovge P0, P1
cmp P2, P3
cmovg S1, P3
cmovle S1, P2
cmovl P2, P3
cmp S1, S2
cmovle P1, S1
mov P3, P0
cmovle S1, S2
cmovl S2, P1
cmp P0, P2
