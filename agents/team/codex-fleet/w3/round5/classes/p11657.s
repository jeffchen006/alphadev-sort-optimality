# n=5 model=out iset=I1 prefix14_class=11657
cmp P1, P3
cmovle S2, P3
cmovl P3, P1
cmovle P1, S2
mov S1, P0
cmp P2, S1
cmovl S1, P2
cmovl P2, P0
mov P0, P1
cmp P2, P0
cmovge P0, P2
cmovle P1, P2
cmp S1, P3
cmovge S2, P3
