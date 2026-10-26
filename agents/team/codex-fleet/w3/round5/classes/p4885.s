# n=5 model=out iset=I1 prefix14_class=4885
mov S2, P3
mov S1, P1
cmp P0, S2
cmovle P3, P0
cmovl P0, S2
cmp P2, P1
cmovle P1, P2
cmovl P2, S1
mov S1, P1
cmp P1, P3
cmovge S1, P3
cmovl P1, P3
cmp P2, P0
cmovle S1, P0
