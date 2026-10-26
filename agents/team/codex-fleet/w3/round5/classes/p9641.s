# n=5 model=out iset=I1 prefix14_class=9641
cmp P3, P2
mov S1, P3
cmovge P3, P2
cmovge P2, S1
mov S1, P1
cmp S1, P0
cmovg S1, P0
cmovl P1, P0
cmp P1, P2
cmovle P0, P1
cmovle P1, P2
cmovl P2, P0
cmp S1, P3
cmovle P1, S1
