# n=5 model=out iset=I1 prefix14_class=4884
mov S1, P3
cmp P2, P1
cmovle S2, P1
cmovl P1, P2
cmovle P2, S2
cmp P0, P3
cmovle P3, P0
cmovle P0, S1
cmovl S1, P3
cmp P3, P1
cmovle P3, P1
cmovge S1, P1
mov S1, P0
cmp P2, P0
