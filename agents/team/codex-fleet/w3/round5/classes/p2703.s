# n=5 model=out iset=I1 prefix14_class=2703
cmp P0, P1
cmovge S2, P0
cmovle S2, P1
cmovle P1, P0
mov P0, P3
cmp P0, P2
cmovl P0, P2
cmovle P2, P3
mov S1, S2
cmp P0, S1
cmovle S1, P0
cmovl P0, S2
cmp P2, P1
mov P0, S1
