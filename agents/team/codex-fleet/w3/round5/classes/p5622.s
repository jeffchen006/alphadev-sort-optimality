# n=5 model=out iset=I1 prefix14_class=5622
mov S2, P2
cmp P2, P0
cmovge S2, P0
cmovl P2, P0
cmp P1, P3
cmovle S1, P1
cmovle P1, P3
cmovl P3, S1
cmp S2, P3
cmovge P0, S2
cmovg S2, P3
cmovge P3, P0
mov P0, P2
cmp P0, P1
