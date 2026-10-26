# n=5 model=out iset=I1 prefix14_class=316
mov S2, P2
cmp P1, P3
cmovg S1, P1
cmovge P1, P3
cmovg P3, S1
cmp P0, S2
cmovg S2, P0
cmovle P2, P0
cmp P1, P2
cmovl P0, P1
cmovge P0, P2
cmovle P1, P2
cmp S2, P3
mov P0, P1
