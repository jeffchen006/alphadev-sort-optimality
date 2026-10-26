# n=5 model=out iset=I1 prefix14_class=6512
cmp P3, P1
cmovge S1, P1
cmovle S1, P3
cmovg P1, P3
cmp P2, P0
cmovge P3, P0
cmovl P3, P2
cmovl P2, P0
mov P0, P2
cmp P1, P2
cmovle P2, P1
cmovl P1, P0
cmp S1, P3
cmovle P1, P3
