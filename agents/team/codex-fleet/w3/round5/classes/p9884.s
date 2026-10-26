# n=5 model=out iset=I1 prefix14_class=9884
cmp P2, P1
mov S2, P0
cmovle S1, P2
cmovge S1, P1
cmovge P1, P2
cmp P0, P3
cmovle S2, P3
cmovle P3, P0
cmovl P0, S2
cmp P1, P0
cmovle P0, P1
cmovge S2, P1
cmp P3, S1
cmovge P1, P3
