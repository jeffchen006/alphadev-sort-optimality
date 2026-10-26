# n=5 model=out iset=I1 prefix14_class=6871
cmp P1, P2
mov S1, P2
cmovle S1, P1
cmovle P1, P2
cmp P0, P3
cmovle P2, P0
mov S2, P1
cmovl P0, P3
cmovl P3, P2
cmp P0, S2
cmovge P1, P0
cmovle S2, P0
cmp S1, P3
cmovge P1, S1
