# n=5 model=out iset=I1 prefix14_class=1248
cmp P0, P2
cmovle S1, P2
cmovg S1, P0
cmovl P2, P0
cmp P1, P3
cmovge P0, P1
cmovle P0, P3
cmovle P3, P1
cmp S1, P0
mov P1, P0
cmovg P1, S1
cmovle P0, S1
cmp P2, P3
cmovge S2, P2
