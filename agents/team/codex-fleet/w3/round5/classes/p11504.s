# n=5 model=out iset=I1 prefix14_class=11504
mov S1, P0
cmp P3, P2
mov S2, P3
cmovle P3, P2
cmovle P2, S2
cmp S1, P1
cmovge S1, P1
cmovle P0, P1
cmp P2, S1
cmovle P1, P2
cmovle P2, S1
cmovle S1, P1
cmp P3, P0
mov S1, P3
