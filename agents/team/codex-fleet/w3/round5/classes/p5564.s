# n=5 model=out iset=I1 prefix14_class=5564
cmp P1, P2
mov S2, P1
cmovle S2, P2
cmovge P1, P2
cmp P0, P3
mov P2, P0
cmovle P0, P3
cmovl P3, P2
mov S1, P3
cmp P1, P3
cmovl P3, P1
cmovg S1, P1
cmp S2, P0
cmovle P1, S1
