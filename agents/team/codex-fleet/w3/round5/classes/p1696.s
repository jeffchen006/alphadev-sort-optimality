# n=5 model=out iset=I1 prefix14_class=1696
cmp P0, P3
cmovle S2, P3
mov S1, P2
cmovl P3, P0
cmovge S2, P0
cmp P1, S1
cmovl P2, P1
cmovl P1, S1
mov P0, P2
cmp P3, P2
cmovl P0, P3
cmovge P2, P3
cmp S2, P1
cmovle P0, P1
